defmodule SnowflexIdTest do
  use ExUnit.Case, async: true
  doctest SnowflexId

  @node_sample 0..SnowflexId.node_limit()
  @seq_sample 0..SnowflexId.sequence_limit()

  test "generate/2" do
    Enum.each(@node_sample, fn i ->
      list =
        Enum.map(@seq_sample, fn j ->
          {:ok, id} = SnowflexId.generate(i, j)
          id
        end)

      assert list == Enum.sort(list)
    end)
  end

  test "generate!/2" do
    Enum.each(@node_sample, fn i ->
      list =
        Enum.map(@seq_sample, fn j ->
          SnowflexId.generate!(i, j)
        end)

      assert list == Enum.sort(list)
    end)
  end
end
