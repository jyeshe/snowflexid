# test setup
sample = 1..10_000
parallel = Enum.max [div(System.schedulers_online(), 2), 1]
time_seconds = 10

Benchee.run(%{
  "ecto_uuid_ets"    => fn ->
    table = :ets.new(:table, [:ordered_set])
    Enum.each(sample, fn _i ->
      record = {Ecto.UUID.generate(), NaiveDateTime.utc_now()}
      :ets.insert(table, record)
    end)
  end,
  "snowflex_ets" => fn ->
    table = :ets.new(:table, [:ordered_set])
    {:ok, snow_seq} = SnowflexSequence.new(1)

    Enum.each(sample, fn _i ->
      record = {SnowflexSequence.generate!(snow_seq), NaiveDateTime.utc_now()}
      :ets.insert(table, record)
    end)
  end,
}, time: time_seconds, parallel: 1)
