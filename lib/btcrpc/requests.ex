defmodule BTCRPC.Requests do
  @moduledoc false

  alias BTCRPC.{BlockInfo, Request}

  @doc """

  """
  @spec uptime([BTCRPC.rpc_opt()]) :: Request.t()
  def uptime(opts \\ []) do
    payload = make_payload("uptime", [], opts)

    Request.new(payload, fn %{"result" => uptime} -> uptime end)
  end

  @doc """

  """
  @spec get_blockcount([BTCRPC.rpc_opt()]) :: Request.t()
  def get_blockcount(opts \\ []) do
    payload = make_payload("getblockcount", [], opts)

    Request.new(payload, fn %{"result" => blockcount} -> blockcount end)
  end

  @doc """

  """
  @spec get_block(String.t(), [BTCRPC.get_block_opts()]) :: Request.t()
  def get_block(block_hash, opts) do
    verbosity = opts[:verbosity] || 1
    payload = make_payload("getblock", [block_hash, verbosity], opts)

    Request.new(payload, fn
      %{"result" => block_info} when is_map(block_info) ->
        BlockInfo.from_weak_map(block_info)

      %{"result" => hash} when is_binary(hash) ->
        hash
    end)
  end

  def get_block_hash(height, opts) do
    payload = make_payload("getblockhash", [height], opts)

    Request.new(payload, fn %{"result" => result} -> result end)
  end

  defp make_payload(method, params, opts) do
    %{
      id: opts[:id] || 1,
      jsonrpc: "2.0",
      method: method,
      params: params
    }
  end
end
