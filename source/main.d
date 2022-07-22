module main;

import std.stdio;

import constants;
import input;
import token;
import parse;
import kuck;
import config;
import startup;

void main(string[] args)
{
	Config config;

	args = ["ass", "--file=test_file.txt"];
	config = GetConfig(args);
	writeln(config);
}
