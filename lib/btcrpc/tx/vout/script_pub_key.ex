defmodule BTCRPC.Tx.VOut.ScriptPubKey do
  @moduledoc """
  Script PubKey struct
  """

  @type t() :: %__MODULE__{
          asm: String.t(),
          hex: String.t(),
          type: String.t()
        }

  defstruct [:asm, :hex, :type]

  def from_weak_map(map) do
    %__MODULE__{
      asm: Map.fetch!(map, "asm"),
      hex: Map.fetch!(map, "hex"),
      type: Map.fetch!(map, "type")
    }
  end
end
