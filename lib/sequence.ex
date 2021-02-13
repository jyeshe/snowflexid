defmodule SnowflexSequence do
  @moduledoc """
  This Sequence module creates an erlang counter and uses it
  as the sequence number part of the SnowflexId.
  """
  @type t :: %SnowflexSequence{
    counter_ref: :counters.counters_ref(),
    node_id: integer
  }
  defstruct [counter_ref: nil, node_id: nil]

  @default_node_id 1

  @spec new(integer) :: {:error, :node_overflow} | {:ok, SnowflexSequence.t()}
  @doc """
  Creates a struct with an erlang counter and associates it to a certain node.
  """
  def new(node_id \\ @default_node_id) do
    if node_id < 0 or node_id > SnowflexId.node_limit() do
      {:error, :node_overflow}
    else
      {:ok, %SnowflexSequence{
          counter_ref: new_counter(),
          node_id: node_id
      }}
    end
  end

  @spec generate!(sequence :: SnowflexSequence.t()) :: integer
  @doc """
  Generates the Id based on the sequence node and counter.

  This is a not thread-safe function, that's why it bangs.any()
  It throws a SnowflexSequenceOverflow in case sequence number
  goes higher than its bits allow when used in parallel.
  """
  def generate!(sequence) do
    count = :counters.get(sequence.counter_ref, 1)
    # restarts to 1 when reachs max sequence number
    if count == SnowflexId.sequence_limit() do
      :counters.put(sequence.counter_ref, 1, 1)
    else
      :counters.add(sequence.counter_ref, 1, 1)
    end
    SnowflexId.generate!(sequence.node_id, count)
  end

  # creates a counter initilized with 1
  defp new_counter() do
    ref = :counters.new(1, [:write_concurrency])
    :counters.put(ref, 1, 1)
    ref
  end
end
