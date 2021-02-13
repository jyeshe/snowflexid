# test setup
sample = 1..10_000
parallel = Enum.max [div(System.schedulers_online(), 2), 1]
time_seconds = 10

# init ETS
SnowflexTable.init([:public, write_concurrency: true])

Benchee.run(%{
  "ecto_uuid" => fn ->
    Enum.each(sample, fn _i -> Ecto.UUID.generate() end)
  end,
  "snowflexid_sequence" => fn ->
      # SnowflexSequence.generate!/1 cannot run in parallel for same sequence
      {:ok, snow_seq} = SnowflexSequence.new(1)

    Enum.each(sample, fn _i ->
      SnowflexSequence.generate!(snow_seq)
    end)
  end,
  "snowflexid_table" => fn ->
    node_id = 1
    Enum.each(sample, fn _i ->
      SnowflexTable.generate(node_id)
    end)
  end,
}, time: time_seconds, parallel: parallel)
