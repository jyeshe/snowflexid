defmodule SnowflexId.ProtocolTest do
  use ExUnit.Case, async: true

  alias SnowflexId.Protocol

  doctest SnowflexId.Protocol

  @node_sample 0..Protocol.node_limit()
  @seq_sample 0..Protocol.sequence_limit()

  test "generate/2" do
    Enum.each(@node_sample, fn i ->
      list =
        Enum.map(@seq_sample, fn j ->
          {:ok, id} = Protocol.generate(i, j)
          id
        end)

      assert list == Enum.sort(list)
    end)
  end

  test "generate!/2" do
    Enum.each(@node_sample, fn i ->
      list =
        Enum.map(@seq_sample, fn j ->
          Protocol.generate!(i, j)
        end)

      assert list == Enum.sort(list)
    end)
  end
end
