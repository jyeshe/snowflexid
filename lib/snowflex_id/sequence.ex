defmodule SnowflexId.Sequence do
  @moduledoc false

  alias SnowflexId.Protocol

  @type t :: %__MODULE__{
          counter_ref: :counters.counters_ref(),
          node_id: integer
        }
  defstruct counter_ref: nil, node_id: nil

  @default_node_id 1

  @doc """
  Creates a struct with an erlang counter and associates it to a certain node.
  """
  @spec new(integer) :: {:error, :node_overflow} | {:ok, t()}
  def new(node_id \\ @default_node_id) do
    if node_id < 0 or node_id > Protocol.node_limit() do
      {:error, :node_overflow}
    else
      {:ok,
       %__MODULE__{
         counter_ref: new_counter(),
         node_id: node_id
       }}
    end
  end

  @doc """
  Generates the Id based on the sequence node and counter.

  This is a not thread-safe function, that's why it bangs.
  It throws a SnowflexSequenceOverflow in case sequence number
  goes higher than its bits allow when used in parallel.
  """
  @spec generate!(sequence :: t()) :: integer
  def generate!(sequence) do
    count = :counters.get(sequence.counter_ref, 1)
    # restarts to 1 when reachs max sequence number
    if count <= Protocol.sequence_limit() do
      :counters.put(sequence.counter_ref, 1, 1)
    else
      :counters.add(sequence.counter_ref, 1, 1)
    end

    Protocol.generate!(sequence.node_id, count)
  end

  # creates a counter initilized with 1
  defp new_counter() do
    ref = :counters.new(1, [])
    :counters.put(ref, 1, 1)
    ref
  end
end
