# config data
sample = 1..10_000
parallel = Enum.max [div(System.schedulers_online(), 2), 1]
time_seconds = 10

# init ETS
SnowflexTable.init([:public, write_concurrency: true])

Benchee.run(%{
  "ecto_uuid" => fn ->
    Enum.each(sample, fn _i -> Ecto.UUID.generate() end)
  end,
  "snowflex_table" => fn ->
    node_id = 1
    Enum.each(sample, fn _i ->
      SnowflexTable.generate(node_id)
    end)
  end,
}, time: time_seconds, parallel: parallel)
