module token;

import std.format;

struct Token
{
    string name;
    double target_value;

    this(in string name, double value)
    {
        this.name = name;
        this.target_value = value;
    }

    string toString() const pure
    {
        return format("(%s %s)", name, target_value);
    }
}
