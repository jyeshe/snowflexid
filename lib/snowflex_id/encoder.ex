defmodule SnowflexId.Encoder do
  @moduledoc """
  Generates Snowflex IDs based on custom epoch after node id and
  sequence number validations.
  """

  @spec node_limit :: integer
  def node_limit, do: 1023

  @spec sequence_limit :: integer
  def sequence_limit, do: 4095

  @elixir_epoch :erlang.universaltime_to_posixtime({{2011, 1, 9}, {9, 46, 8}}) * 1000

  def custom_epoch(), do: Application.get_env(:snowflexid, :custom_epoch, @elixir_epoch)

  @doc """
  Generates the id for a node continuing with the sequence number.

  Raises `SnowflexId.SequenceOverflowError` or `SnowflexId.NodeOverflowError`
  if a param is out of bounds.
  """
  @spec generate!(integer, integer) :: integer
  def generate!(node_id, sequence_num) do
    cond do
      sequence_num > sequence_limit() ->
        raise SnowflexId.SequenceOverflowError, sequence_number: sequence_num, sequence_max: sequence_limit()

      node_id > node_limit() ->
        raise SnowflexId.NodeOverflowError, node_id: node_id, node_limit: node_limit()

      true ->
        new_id(node_id, sequence_num)
    end
  end

  @doc "Generates an id for a node continuing with the sequence number."
  @spec generate(integer, integer) :: {:ok, integer} | {:error, :sequence_overflow | :node_overflow}
  def generate(node_id, sequence_num)  do
    cond do
      sequence_num > sequence_limit() ->
        {:error, :sequence_overflow}

      node_id > node_limit() ->
        {:error, :node_overflow}

      true ->
        {:ok, new_id(node_id, sequence_num)}
    end
  end

  defp new_id(node_id, seq_num) do
    ts = :os.system_time(:millisecond) - custom_epoch()

    :binary.decode_unsigned(<<0::1, ts::41, node_id::10, seq_num::12>>)
  end
end
