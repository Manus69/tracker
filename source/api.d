module api;

import binance;
import kuck;
import constants;

abstract class Api
{
    string          RequestAllPrices() const;
    string[string]  GetPriceTable() const;
}

Api GetApi(in string str)
{
    if (str == BINANCE_STR)
        return new Binance();
    if (str == KUCK_STR)
        return new Kuck();

    throw new Exception(ERROR_MSG_GENERIC);
}
