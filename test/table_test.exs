defmodule SnowflexTableTest do
  use ExUnit.Case, async: true
  doctest SnowflexTable

  @node_sample 1..SnowflexId.node_limit()
  @seq_sample 1..SnowflexId.sequence_limit()

  test "generate/1" do
    SnowflexTable.init()

    Enum.each(@node_sample, fn node_id ->
      list =
        Enum.map(@seq_sample, fn _j ->
          {:ok, id} = SnowflexTable.generate(node_id)
          id
        end)

      assert list == Enum.sort(list)
    end)
  end
end
