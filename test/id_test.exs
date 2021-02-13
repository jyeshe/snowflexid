defmodule SnowflexId.IdHelperTest do
  use ExUnit.Case, async: true

  alias SnowflexId.IdHelper

  doctest SnowflexId.IdHelper

  @node_sample 0..IdHelper.node_limit()
  @seq_sample 0..IdHelper.sequence_limit()

  test "generate/2" do
    Enum.each(@node_sample, fn i ->
      list =
        Enum.map(@seq_sample, fn j ->
          {:ok, id} = IdHelper.generate(i, j)
          id
        end)

      assert list == Enum.sort(list)
    end)
  end

  test "generate!/2" do
    Enum.each(@node_sample, fn i ->
      list =
        Enum.map(@seq_sample, fn j ->
          IdHelper.generate!(i, j)
        end)

      assert list == Enum.sort(list)
    end)
  end
end
