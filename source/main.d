module main;

import std.stdio;

import constants;
import config;
import startup;
import run;
import output;

void main(string[] args)
{
	Config config;
	
	// args = ["ass", "--file=test_file.txt"];
	try
	{
		config = GetConfig(args);
	}
	catch (Exception ex)
	{
		stderr.writeln(ex.msg);
		return DisplayHelp();
	}

	Run(config);
}
