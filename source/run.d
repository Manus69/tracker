module run;

import constants;
import config;
import input_adapter;
import token;

void Run(Config config)
{
    Token[][string] token_table;

    token_table = GetTokenTable(config);
    while (true)
    {
        if (config.InputChanged)
            token_table = GetTokenTable(config);
        
        
    }
}