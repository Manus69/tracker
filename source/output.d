module output;

import std.stdio;
public import std.process : executeShell;

import token;
import config;
import constants;

enum string PLAY_SOUND_COMMAND = "open " ~ SOUND_FNAME;

void DisplayOutput(in Config config, in Token[] tokens)
{
    writeln("\n", tokens, "\n");

    if (config.play_sound)
        executeShell(PLAY_SOUND_COMMAND);
}

void DisplayHelp()
{
    writeln(HELP_MESSAGE);   
}