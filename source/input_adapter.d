module input_adapter;

import std.file;
import std.array;
import std.algorithm;

import config;
import token;
import input;
import parse;
import constants;
import binance;

Token[][string] GetTokenTable(Config config)
{
    Token[][string] table;
    string[]        strings;
    string[]        slice;
    Token[]         tokens;

    strings = FileToStrings(config.input_file_name);

    foreach (api_name; config.apis.keys)
    {
        slice = GetSlice(strings, DELIMITER_STR ~ api_name, DELIMITER_STR);
        tokens = TokensFromLines(slice);
        table[api_name] = tokens;
    }

    if (table[BINANCE_STR].find!((a) => a.name == BINANCE_BTCUSDT_STR).empty)
        table[BINANCE_STR] ~= Token(BINANCE_BTCUSDT_STR, double.nan);

    config.UpdateTime();

    return table;
}