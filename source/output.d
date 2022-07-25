module output;

import std.stdio;

import token;
import config;

void DisplayOutput(in Config config, in Token[] tokens)
{
    writeln("\n", tokens, "\n");
}