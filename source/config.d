module config;

import std.datetime;
import std.file;

import api;
import kuck;
import binance;
import constants;

class Config
{
    Api[string] apis;
    string      input_file_name;
    string      sound_file_name;
    ulong       delay;
    ulong       interval;
    SysTime     tolm;
    bool        play_sound;

    this()
    {
        sound_file_name = SOUND_FNAME;
        play_sound = false;
    }

    Config SetApis()
    {
        apis[BINANCE_STR] = new Binance();
        apis[KUCK_STR] = new Kuck();

        return this;
    }

    Config SetInputFile(in string name) pure
    {
        input_file_name = name;

        return this;
    }

    Config SetDelay(ulong delay) pure
    {
        this.delay = delay;

        return this;
    }

    Config SetInterval(ulong interval) pure
    {
        this.interval = interval;

        return this;
    }

    bool InputChanged() const @property
    {
        return input_file_name.timeLastModified != tolm;
    }

    void UpdateTime()
    {
        tolm = input_file_name.timeLastModified;
    }
}
