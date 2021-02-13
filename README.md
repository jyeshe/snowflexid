# SnowflexId

Generator of Snowflake ID which is smaller and faster than UUID (but not random).

It's ordered by timestamp after Elixir time (epoch since 2011-01-09) and 
avoid colissions in cluster based on process generator id which here is called node id.

The ID is an integer that fits into a PostgreSQL biginit and it's composed by:
  41 bits of timestamp with millisecond precision, using a custom epoch.
  10 bits of node id - a range from 0 through 1023.
  12 bits of a sequence number - a range from 0 through 4095.

## Usage

The generator is available in 2 flavors: 
A. Sequence (erlang counter)
B. Table (erlang ets)

A. Sequence

This option is not thread-safe due to sequence restart after reaching the bits limit.
But it's faster due to erlang counter and it might be usefull when generating inside a GenServer.

B. Table

This is arround 2.5x slower than Sequence but it's a thread-safe table that 
serves multiple node ids.

## Configuration

This is optional if you want to setup a custom epoch (in milliseconds).

config :snowflex, epoch, 1294566368000

## Installation

```elixir
def deps do
  [
    {:snowflex, "~> 0.1.0"}
  ]
end
```
