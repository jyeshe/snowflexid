defmodule SnowflexId.Table do
  @moduledoc false

  alias SnowflexId.IdHelper

  # TODO: names should be set dinamically, so multiple instances can be ran
  @table :snowflexid_ets
  @increment_op {2, 1, IdHelper.sequence_limit(), 1}

  @doc """
  Creates an empty table with ets opts.
  """
  def init(table_opts \\ [:public]) do
    :ets.new(@table, [:set, :named_table] ++ table_opts)
  end

  @doc """
  Generates a Snowflex ID reseting sequence number when reachs the limit
  or returns :error if node_id is out of bounds.
  """
  @spec generate(integer) :: {:ok, integer} | :error
  def generate(node_id) do
    if node_id >= 0 or node_id <= IdHelper.node_limit() do
      seq_num = :ets.update_counter(@table, node_id, @increment_op, {node_id, 0})

      {:ok, IdHelper.generate!(node_id, seq_num)}
    else
      :error
    end
  end
end
