module kuck;

import std.json;
import std.array;
import std.net.curl;

import api;
import constants;

enum string KUCK_STR = "Kuck";
enum string KUCK_DSTR = DELIMITER_STR ~ KUCK_STR;
private enum API = "https://api.kucoin.com/api/";
private enum REQUEST = "https://api.kucoin.com/api/v1/prices?base=USD";
private enum DATA_KEY = "data";

class Kuck : Api
{
    override string GetRequestMessage() const
    {
        return super.GetMsg() ~ API;
    }

    override string RequestAllPrices() const
    {
        return get(REQUEST).idup;
    }

    override string MapExtToInt(in string str) const
    {
        return str;
    }

    override string MapIntToExt(in string str) const
    {
        return str;
    }

    override string[string] GetPriceTable() const
    {
        string[string]  table;
        JSONValue       json;
        string          response;

        response = RequestAllPrices();
        json = parseJSON(response)[DATA_KEY];

        foreach (string key, JSONValue value; json)
        {
            table[MapExtToInt(key)] = value.str;
        }

        return table;
    }
}