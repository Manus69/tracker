module run;

import std.stdio;
import std.conv;
import std.datetime;
import std.parallelism;
import core.thread;

import constants;
import config;
import input_adapter;
import token;
import queue;
import binance;
import output;
import api; 

enum string ERROR_MSG_TOKEN = "Token not found: ";

void ProcessTokens(Queue!double[string][string] queues,
    in Token[][string] token_table, in Config config, in string api_string)
{
    string[string]  response_table;
    Api             api;

    api = cast(Api)config.apis[api_string];
    // response_table = config.apis[api_string].GetPriceTable();
    response_table = api.GetPriceTable();
    writeln(api.GetRequestMessage());

    foreach (ref token; token_table[api_string])
    {
        if (token.name in response_table)
        {
            // writeln(token.name, " ", response_table[token.name]);
            (queues[api_string][token.name]).Push(to!double(response_table[token.name]));
        }
        else
            stderr.writeln(ERROR_MSG_TOKEN, token.name);
    }
}

Queue!double[string][string] BuildQueues(in Token[][string] token_table, ulong size)
{
    Queue!double[string][string] queues;

    foreach (api_string; token_table.keys)
    {
        foreach (ref token; token_table[api_string])
        {
            queues[api_string][token.name] = Queue!double(size);
        }
    }

    return queues;
}

double ComputeDiff(double lhs, double rhs)
{
    return ((rhs - lhs) / lhs) * 100;
}

bool CheckPriceCondition(in Queue!double[string][string] queues, in Token token,
    in string api_name, double btcusdt0, double btcusdt1)
{
    double price0;
    double price1;
    double diff;

    price0 = queues[api_name][token.name].Front();
    price1 = queues[api_name][token.name].Back();
    diff = ComputeDiff(price0 / btcusdt0, price1 / btcusdt1);
    
    if (api_name == BINANCE_STR && token.name == BINANCE_BTCUSDT_STR)
        diff = ComputeDiff(price1, price0);

    // writefln("%s %s p: %s %s; b: %s %s", api_name, token.name, price0, price1, btcusdt0, btcusdt1);

    return diff > token.target_value;
}

Token[] CheckQueues(in Queue!double[string][string] queues, in Token[][string] token_table)
{
    Token[] tokens;
    double  btcusdt0;
    double  btcusdt1;

    if (!queues[BINANCE_STR][BINANCE_BTCUSDT_STR].FullCapacity)
        return [];
    
    btcusdt0 = queues[BINANCE_STR][BINANCE_BTCUSDT_STR].Front();
    btcusdt1 = queues[BINANCE_STR][BINANCE_BTCUSDT_STR].Back();
    
    foreach (api_name; token_table.keys)
    {
        foreach (token; token_table[api_name])
        {
            if (CheckPriceCondition(queues, token, api_name, btcusdt0, btcusdt1))
                tokens ~= token;
        }
    }

    return tokens;
}

void Run(Config config)
{
    Token[][string]                 token_table;
    Queue!double[string][string]    queues;
    Token[]                         tokens;

    token_table = GetTokenTable(config);
    queues = BuildQueues(token_table, (config.interval * 60) / config.delay);

    while (true)
    {
        if (config.InputChanged)
            token_table = GetTokenTable(config);
        
        foreach (api_string; parallel(token_table.keys))
        {
            ProcessTokens(queues, token_table, config, api_string);
        }

        tokens = CheckQueues(queues, token_table);
        if (tokens.length)
            DisplayOutput(config, tokens);

        writeln(queues);
        Thread.sleep(config.delay.seconds);
    }
}