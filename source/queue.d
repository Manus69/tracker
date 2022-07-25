module queue;

import std.range;
import std.format;

struct Queue(T)
{
    private ulong   size;
    private T[]     values;

    this(ulong size)
    {
        this.size = size;
    }

    bool FullCapacity() const pure @property
    {
        return values.length == size;
    }

    void Push(in T value)
    {
        if (FullCapacity)
            values.popFront();
        
        values ~= value;
    }

    void Push(in T[] values...)
    {
        foreach (v; values)
            Push(v);
    }

    auto ref T opIndex(ulong n) const pure
    {
        return values[n];
    }

    auto ref T Front() const pure
    {
        return values[0];
    }

    auto ref T Back() const pure
    {
        return values[$ - 1];
    }

    string toString() const
    {
        return format("%s", values);
    }
}