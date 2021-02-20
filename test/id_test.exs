defmodule SnowflexId.EncoderTest do
  use ExUnit.Case, async: true

  alias SnowflexId.Encoder

  doctest SnowflexId.Encoder

  @node_sample 0..Encoder.node_limit()
  @seq_sample 0..Encoder.sequence_limit()

  test "generate/2" do
    Enum.each(@node_sample, fn i ->
      list =
        Enum.map(@seq_sample, fn j ->
          {:ok, id} = Encoder.generate(i, j)
          id
        end)

      assert list == Enum.sort(list)
    end)
  end

  test "generate!/2" do
    Enum.each(@node_sample, fn i ->
      list =
        Enum.map(@seq_sample, fn j ->
          Encoder.generate!(i, j)
        end)

      assert list == Enum.sort(list)
    end)
  end
end
