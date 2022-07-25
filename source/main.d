module main;

import std.stdio;

import constants;
import input;
import token;
import parse;
import kuck;
import config;
import startup;
import run;

//McMains and Mullins
void main(string[] args)
{
	Config config;


	// string[string][string] table;
	// table["ass"]["cock"] = "penis";

	// writeln(table["ass"]["cock"]);
	
	args = ["ass", "--file=test_file.txt"];
	config = GetConfig(args);

	Run(config);
}
