defmodule BTCRPC.BlockInfo do
  @moduledoc """
  Block info
  """

  alias BTCRPC.Tx

  @type t() :: %__MODULE__{
          bits: String.t(),
          chain_work: String.t(),
          confirmations: non_neg_integer(),
          difficulty: float(),
          hash: String.t(),
          height: pos_integer(),
          median_time: non_neg_integer(),
          merkle_root: String.t(),
          n_tx: non_neg_integer(),
          tx: [String.t()] | [Tx.t()]
        }

  defstruct [
    :bits,
    :chain_work,
    :confirmations,
    :difficulty,
    :hash,
    :height,
    :median_time,
    :merkle_root,
    :n_tx,
    :nonce,
    :previous_block_hash,
    :size,
    :stripped_size,
    :time,
    :tx,
    :version,
    :version_hex,
    :weight
  ]

  @doc """
  Marshal a stringed keyed map into the BlockInfo struct
  """
  @spec from_weak_map(map()) :: t()
  def from_weak_map(weak_map) do
    %__MODULE__{
      bits: Map.fetch!(weak_map, "bits"),
      chain_work: Map.fetch!(weak_map, "chainwork"),
      confirmations: Map.fetch!(weak_map, "confirmations"),
      difficulty: Map.fetch!(weak_map, "difficulty"),
      hash: Map.fetch!(weak_map, "hash"),
      height: Map.fetch!(weak_map, "height"),
      median_time: Map.fetch!(weak_map, "mediantime"),
      merkle_root: Map.fetch!(weak_map, "merkleroot"),
      n_tx: Map.fetch!(weak_map, "nTx"),
      nonce: Map.fetch!(weak_map, "nonce"),
      previous_block_hash: Map.fetch!(weak_map, "previousblockhash"),
      size: Map.fetch!(weak_map, "size"),
      stripped_size: Map.fetch!(weak_map, "strippedsize"),
      time: Map.fetch!(weak_map, "time"),
      tx: parse_tx(Map.fetch!(weak_map, "tx")),
      version: Map.fetch!(weak_map, "version"),
      version_hex: Map.fetch!(weak_map, "versionHex"),
      weight: Map.fetch!(weak_map, "weight")
    }
  end

  defp parse_tx(tx) do
    Enum.map(tx, fn
      tx when is_binary(tx) -> tx
      tx when is_map(tx) -> Tx.from_weak_map(tx)
    end)
  end

  def get_tx(block_info, txid) do
    Enum.find(block_info.tx, &(&1.txid == txid))
  end
end
