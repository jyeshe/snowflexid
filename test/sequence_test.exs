defmodule SnowflexSequenceTest do
  use ExUnit.Case, async: true

  alias SnowflexId.Sequence

  doctest Sequence

  @node_sample 1..SnowflexId.Protocol.node_limit()
  @seq_sample 1..SnowflexId.Protocol.sequence_limit()

  test "generate!/1" do
    Enum.each(@node_sample, fn i ->
      {:ok, snow_seq} = Sequence.new(i)

      list =
        Enum.map(@seq_sample, fn _j ->
          Sequence.generate!(snow_seq)
        end)

      assert list == Enum.sort(list)
    end)
  end
end
