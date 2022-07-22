module binance;

import std.net.curl;
import std.array;
import std.json;

import constants;
import api;

enum string BINANCE_STR = "Binance";
enum string BINANCE_DSTR = DELIMITER_STR ~ BINANCE_STR;
private enum API = "https://api.binance.com/api/";
private enum REQUEST = "https://api.binance.com/api/v3/ticker/price";
private enum SEP = "},";
private enum SYMBOL_KEY = "symbol";
private enum PRICE_KEY = "price";

class Binance : Api
{
    override string RequestAllPrices() const
    {
        return get(REQUEST).idup;
    }

    override string[string] GetPriceTable() const
    {
        string[string]  table;
        string[]        data;
        string          response;
        JSONValue       json;

        response = RequestAllPrices();
        if (!response || response.length < 5)
            return null;

        response = response[1 .. $];
        data = split(response, SEP);

        foreach(str; data)
        {
            str = str ~ "}";
            json = parseJSON(str);
            table[json[SYMBOL_KEY].str] = json[PRICE_KEY].str;
        }

        return table;
    }
}
