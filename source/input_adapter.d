module input_adapter;

import std.file;

import config;
import token;
import input;
import parse;
import constants;

Token[][string] GetTokenTable(Config config)
{
    Token[][string] table;
    string[]        strings;
    string[]        slice;
    Token[]         tokens;

    strings = FileToStrings(config.input_file_name);

    foreach (api_name; config.apis.keys)
    {
        slice = GetSlice(strings, DELIMITER_STR ~ api_name, DELAY_STR);
        tokens = TokensFromLines(slice);
        table[api_name] = tokens;
    }

    config.UpdateTime();
    
    return table;
}