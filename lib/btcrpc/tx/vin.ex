defmodule BTCRPC.Tx.VIn do
  @moduledoc """
  Transaction Input
  """

  @type t() :: %__MODULE__{
          coinbase: String.t(),
          sequence: non_neg_integer(),
          txinwitness: [String.t()]
        }

  defstruct [:coinbase, :sequence, :txinwitness]

  @doc """
  Marshal a stringed keyed map into a VIn struct
  """
  @spec from_weak_map(map()) :: t()
  def from_weak_map(map) do
    %__MODULE__{
      coinbase: Map.fetch!(map, "coinbase"),
      sequence: Map.fetch!(map, "sequence"),
      txinwitness: Map.fetch!(map, "txinwitness")
    }
  end
end
