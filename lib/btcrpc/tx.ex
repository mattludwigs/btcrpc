defmodule BTCRPC.Tx do
  @moduledoc """
  """

  alias BTCRPC.Tx.{VIn, VOut}

  @type t() :: %__MODULE__{
          hash: String.t(),
          hex: String.t(),
          locktime: non_neg_integer(),
          version: non_neg_integer(),
          size: non_neg_integer(),
          vin: [VIn.t()],
          vout: [VOut.t()],
          vsize: non_neg_integer(),
          weight: non_neg_integer()
        }

  defstruct [:hash, :hex, :locktime, :size, :txid, :version, :vin, :vout, :vsize, :weight]

  @doc """
  Marshal a stringed keyed map into a Tx
  """
  @spec from_weak_map(map()) :: t()
  def from_weak_map(map) do
    %__MODULE__{
      hash: Map.fetch!(map, "hash"),
      hex: Map.fetch!(map, "hex"),
      locktime: Map.fetch!(map, "locktime"),
      size: Map.fetch!(map, "size"),
      vsize: Map.fetch!(map, "vsize"),
      weight: Map.fetch!(map, "weight"),
      version: Map.fetch!(map, "version"),
      txid: Map.fetch!(map, "txid"),
      vin: Enum.map(Map.fetch!(map, "vin"), &VIn.from_weak_map/1),
      vout: Enum.map(Map.fetch!(map, "vout"), &VOut.from_weak_map/1)
    }
  end

  @doc """
  Get the output by output `n`
  """
  @spec get_output(t(), non_neg_integer()) :: VOut.t()
  def get_output(tx, out_n) do
    Enum.find(tx.vout, &(&1.n == out_n))
  end
end
