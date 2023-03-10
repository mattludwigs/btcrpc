defmodule BTCRPC.Requests do
  @moduledoc false

  alias BTCRPC.Request

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

  defp make_payload(method, params, opts) do
    %{
      id: opts[:id] || 1,
      jsonrpc: "2.0",
      method: method,
      params: params
    }
  end
end
