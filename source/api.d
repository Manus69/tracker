module api;

import binance;
import kuck;
import constants;

enum string API_REQUEST_MESSAGE = "Requesting data from ";

abstract class Api
{
    string[string]  GetPriceTable() const;
    string          RequestAllPrices() const;
    string          GetRequestMessage() const;
    string          MapExtToInt(in string str) const;
    string          MapIntToExt(in string str) const;
    
    string GetMsg() const
    {
        return API_REQUEST_MESSAGE;
    }
}

