module input;

import std.stdio;
import std.conv;
import std.string;
import std.algorithm;

import constants;

string[] FileToStrings(in string file_name)
{
    File        file;
    string[]    lines;

    file = File(file_name);
    foreach (line; file.byLineCopy())
    {
        if (line.length && !line.startsWith(COMMENT_STR))
            lines ~= line;
    }

    return lines;
}

private string[] _append_lines(in string[] lines, in string terminator)
{
    string[] result;

    foreach (line; lines)
    {
        if (line.startsWith(terminator))
            break ;
        
        result ~= line;
    }

    return result;
}

string[] GetSlice(in string[] lines, in string start, in string terminator)
{
    foreach (j, line; lines)
    {
        if (line == start)
            return _append_lines(lines[j + 1 .. $], terminator);
    }

    return [];
}

