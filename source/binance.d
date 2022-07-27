module binance;

import std.net.curl;
import std.array;
import std.json;
import std.string;

import constants;
import api;

enum string BINANCE_STR = "Binance";
enum string BINANCE_DSTR = DELIMITER_STR ~ BINANCE_STR;
enum string BINANCE_BTCUSDT_STR = "BTC";
enum string BINANCE_SUFFIX = "USDT";
private enum API = "https://api.binance.com/api/";
private enum REQUEST = "https://api.binance.com/api/v3/ticker/price";
private enum SEP = "},";
private enum SYMBOL_KEY = "symbol";
private enum PRICE_KEY = "price";

class Binance : Api
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
        return endsWith(str, BINANCE_SUFFIX) ? str[0 .. $ - BINANCE_SUFFIX.length] : str;
    }

    override string MapIntToExt(in string str) const
    {
        return str ~ BINANCE_SUFFIX;
    }

    override string[string] GetPriceTable() const
    {
        string[string]  table;
        string[]        data;
        string          response;
        string          token_name;
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
            token_name = MapExtToInt(json[SYMBOL_KEY].str);
            // token_name = json[SYMBOL_KEY].str;
            table[token_name] = json[PRICE_KEY].str;
        }

        return table;
    }
}
