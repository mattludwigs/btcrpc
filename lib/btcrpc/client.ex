defmodule BTCRPC.Client do
  @doc false

  use GenServer

  alias BTCRPC.Config

  @type args() :: [config: Config.t(), adapter: module()]

  @doc """
  Start the RPC client
  """
  @spec start_link(args()) :: GenServer.on_start()
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: name(args[:name]))
  end

  defp name(nil), do: __MODULE__
  defp name(name) when is_pid(name), do: name
  defp name(name), do: {:via, Registry, {BTCRPC.ServerRegistry, name}}

  def rpc_request(payload, opts \\ []) do
    GenServer.call(name(opts[:server]), {:rpc_request, payload})
  end

  @impl GenServer
  def init(args) do
    config = Keyword.fetch!(args, :config)
    {:ok, adapter_state} = config.adapter.init(config)

    {:ok, %{adapter: config.adapter, adapter_state: adapter_state}}
  end

  @impl GenServer
  def handle_call({:rpc_request, payload}, _from, state) do
    case state.adapter.send_rpc_request(payload, state.adapter_state) do
      {:ok, result, updated_adapter_state} ->
        {:reply, {:ok, result}, %{state | adapter_state: updated_adapter_state}}
    end
  end
end
