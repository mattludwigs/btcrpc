defmodule BTCRPC.Client.DefaultAdapter do
  @moduledoc """
  Default client adapter used by BTCRPC

  This adapter uses the `:req` HTTP library for the implementation
  """

  @behaviour BTCRPC.Client.Adapter

  alias BTCRPC.Request

  @impl BTCRPC.Client.Adapter
  def init(config) do
    endpoint = "#{config.hostname}:#{config.port}"

    {:ok, %{endpoint: endpoint, user: config.user, password: config.password}}
  end

  @impl BTCRPC.Client.Adapter
  def send_rpc_request(request, state) do
    case Req.post(state.endpoint, json: request.payload, auth: {state.user, state.password}) do
      {:ok, %{status: 200} = resp} ->
        ret = Request.handle_response(request, resp.body)
        {:ok, ret, state}
    end
  end
end
