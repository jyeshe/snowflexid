defmodule SnowflexId.TableTest do
  use ExUnit.Case, async: true

  alias SnowflexId.Table

  doctest Table

  @node_sample 1..SnowflexId.Encoder.node_limit()
  @seq_sample 1..SnowflexId.Encoder.sequence_limit()

  test "generate/1" do
    Table.init()

    Enum.each(@node_sample, fn node_id ->
      list =
        Enum.map(@seq_sample, fn _j ->
          {:ok, id} = Table.generate(node_id)
          id
        end)

      assert list == Enum.sort(list)
    end)
  end
end
