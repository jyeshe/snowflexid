# test setup
sample = 1..10_000
parallel = Enum.max [div(System.schedulers_online(), 2), 1]
time_seconds = 10

Benchee.run(%{
  "ecto_uuid" => fn ->
    Enum.each(sample, fn _i -> Ecto.UUID.generate() end)
  end,
  "snowflex_sequence" => fn ->
      node_id = SnowflexId.node_limit()
      # SnowflexSequence.generate!/1 cannot run in parallel for same sequence
      {:ok, snow_seq} = SnowflexSequence.new(node_id)

    Enum.each(sample, fn _i ->
      SnowflexSequence.generate!(snow_seq)
    end)
  end,
}, time: time_seconds, parallel: parallel)
