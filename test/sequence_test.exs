defmodule SnowflexSequenceTest do
  use ExUnit.Case, async: true
  doctest SnowflexSequence

  @node_sample 1..SnowflexId.node_limit()
  @seq_sample 1..SnowflexId.sequence_limit()

  test "generate!/1" do
    Enum.each(@node_sample, fn i ->
      {:ok, snow_seq} = SnowflexSequence.new(i)

      list =
        Enum.map(@seq_sample, fn _j ->
          SnowflexSequence.generate!(snow_seq)
        end)

      assert list == Enum.sort(list)
    end)
  end
end
