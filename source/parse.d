module parse;

import std.string;
import std.exception;
import std.conv;

import constants;
import token;

enum string PARSE_FAILURE_MSG = "Parsing failed: ";

Token TokenFromString(in string str)
{
    string[]    substrings;
    Token       token;
    double      value;

    substrings = split(str, SEP_STR);

    if (substrings.length < 2)
        throw new Exception(PARSE_FAILURE_MSG ~ str);
    
    if (substrings.length > 2 && !substrings[2].startsWith(COMMENT_STR))
        throw new Exception(PARSE_FAILURE_MSG ~ str);
    
    value = to!double(substrings[1]);
    token = Token(substrings[0], value);

    return token;
}

Token[] TokensFromLines(in string[] lines)
{
    Token[] tokens;

    foreach (line; lines)
        tokens ~= TokenFromString(line);

    return tokens;
}