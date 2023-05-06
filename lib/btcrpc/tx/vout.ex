defmodule BTCRPC.Tx.VOut do
  @moduledoc """
  Transaction output
  """

  alias BTCRPC.Tx.VOut.ScriptPubKey

  @type t() :: %__MODULE__{
          n: non_neg_integer(),
          script_pubkey: ScriptPubKey.t(),
          value: float()
        }

  defstruct [:n, :script_pubkey, :value]

  @doc """
  Marshal a stringed keyed map into the VOut struct
  """
  @spec from_weak_map(map()) :: t()
  def from_weak_map(map) do
    %__MODULE__{
      n: Map.fetch!(map, "n"),
      script_pubkey: ScriptPubKey.from_weak_map(Map.fetch!(map, "scriptPubKey")),
      value: Map.fetch!(map, "value")
    }
  end
end
