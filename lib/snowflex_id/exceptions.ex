defmodule SnowflexId.SequenceOverflowError do
  defexception [:message, :sequence_number, :sequence_max]

  def exception(opts) do
    seq_num = Keyword.fetch!(opts, :sequence_number)
    max = Keyword.fetch!(opts, :sequence_max)

    %__MODULE__{
      message: "received #{seq_num}, expected up to #{max}",
      sequence_number: seq_num,
      sequence_max: max
    }
  end
end

defmodule SnowflexId.NodeOverflowError do
  defexception [:message, :node_id, :node_max]

  def exception(opts) do
    node_id = Keyword.fetch!(opts, :node_id)
    max = Keyword.fetch!(opts, :node_max)

    %__MODULE__{
      message: "received #{node_id}, expected up to #{max}",
      node_id: node_id,
      node_max: max
    }
  end
end
