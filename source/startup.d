module startup;

import std.stdio;
import std.getopt;
import std.conv;
import std.exception;

import config;
import binance;
import kuck;
import constants;

enum ARG_ERROR_MSG = "Failed to parse input arguments: ";

Config GetConfig(string[] args)
{
    Config  config;
    string  file_name;
    ulong   delay;
    ulong   interval;

    enforce(args.length > 1);
    
    try
    {
        getopt(args, FILE_STR, &file_name, DELAY_STR, &delay, INTERVAL_STR, &interval);
        enforce(file_name);
        delay = delay ? delay : DELAY_DEFAULT;
        interval = interval ? interval : INTERVAL_DEFAULT;
    }
    catch (Exception ex)
    {
        throw new Exception(ARG_ERROR_MSG ~ ex.msg);
    }

    config = new Config();
    config.SetInputFile(file_name);
    config.SetDelay(delay);
    config.SetInterval(interval);
    config.SetApis();

    return config;
}