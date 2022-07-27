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
	
	try
	{
		config = GetConfig(args);
	}
	catch (Exception ex)
	{
		stderr.writeln(ex.msg);
		return DisplayHelp();
	}

	try
	{
		Run(config);
	}
	catch (Exception ex)
	{
		stderr.writeln(ex.msg);
		stderr.writeln(ERROR_MSG_GENERIC);
	}
}
