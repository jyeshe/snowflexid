defmodule SnowflexId.Protocol do
  @moduledoc """
  Defines ID generation rules and generates Snowflex IDs.
  """

  @spec node_limit :: integer
  def node_limit, do: 1023

  @spec sequence_limit :: integer
  def sequence_limit, do: 4095

  @elixir_epoch :erlang.universaltime_to_posixtime({{2011, 1, 9}, {9, 46, 8}}) * 1000

  # TODO: receive this as an option or, at least, fetch dinamically, libraries
  # shouldnt rely on recompilation to change options
  @custom_epoch Application.get_env(:snowflexid, :epoch, @elixir_epoch)

  @doc """
  Generates the id for a node continuing with the sequence number.
  Throws SnowflexSequeceOverflow or SnowflexNodeOverflow if a param is out of bounds.
  """
  @spec generate!(integer, integer) :: integer
  def generate!(node_id, sequence_num) do
    cond do
      sequence_num > sequence_limit() ->
        throw(SnowflexSequeceOverflow)

      node_id > node_limit() ->
        throw(SnowflexNodeOverflow)

      true ->
        new_id(node_id, sequence_num)
    end
  end

  @doc """
  Generates an id for a node continuing with the sequence number.
  Returns {:error, :sequence_overflow} or {:error, :node_overflow} if a param is out of bounds.
  """
  @spec generate(integer, integer) :: {:ok, integer} | {:error, :sequence_overflow | :node_overflow}
  def generate(node_id, sequence_num) do
    cond do
      sequence_num > sequence_limit() ->
        {:error, :sequence_overflow}

      node_id > node_limit() ->
        {:error, :node_overflow}

      true ->
        {:ok, new_id(node_id, sequence_num)}
    end
  end

  defp new_id(node_id, seq_num, opts \\ []) do
    ts = :os.system_time(:millisecond) - Keyword.get(opts, :epoch, @elixir_epoch)

    :binary.decode_unsigned(<<0::1, ts::41, node_id::10, seq_num::12>>)
  end
end