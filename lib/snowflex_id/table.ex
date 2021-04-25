defmodule SnowflexId.Table do
  @moduledoc """
  Keeps track of Snowflex nodes and sequential number with ETS.
  """

  alias SnowflexId.Encoder

  @table :snowflexid_ets
  @increment_op {2, 1, Encoder.sequence_limit(), 1}

  @doc """
  Creates an empty table with ets opts.
  """
  @spec init(list()) :: true
  def init(table_opts \\ [:public]) do
    :ets.new(@table, [:set, :named_table] ++ table_opts)
  end

  @doc """
  Generates a Snowflex ID reseting sequence number when reachs the limit.

  Raises `SnowflexId.NodeOverflowError` when node_id is not between 0 and 1023
  """
  @spec generate!(integer()) :: integer()
  def generate!(node_id) do
    seq_num = :ets.update_counter(@table, node_id, @increment_op, {node_id, 0})

    Encoder.generate!(node_id, seq_num)
  end
end
