defmodule BTCRPC do
  @moduledoc """
  RPC client for bitcoin core
  """

  alias BTCRPC.{Client, Config, Requests}

  @typedoc """
  Configuration args for single BTC RPC server
  """
  @type rpc_server_args() :: [
          hostname: :inet.hostname(),
          port: :inet.port_number(),
          user: String.t(),
          password: String.t(),
          adapter: module()
        ]

  @typedoc """
  Arguments to start BTCRPC

  If you only need to communicate to one bitcoin node you can pass the fields
  from `rpc_server_args()`.

  However, if you want to send messages to more than one RPC server you may
  provide a map under the `:servers` key that will map the name of the server to
  its configuration, which is of type `rpc_server_args()`.
  """
  @type btc_rpc_args() ::
          rpc_server_args() | [servers: %{String.t() => rpc_server_args()}]

  @typedoc """
  """
  @type rpc_opt() :: {:server, String.t()} | {:id, integer()}

  use Supervisor

  @doc """
  Start BTCRPC
  """
  @spec start_link(btc_rpc_args()) :: Supervisor.on_start()
  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl Supervisor
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one)
  end

  defp children(args) do
    children = [
      {Registry, [keys: :unique, name: BTCRPC.ServerRegistry]}
    ]

    if args[:servers] != nil do
      add_server_clients(children, args)
    else
      config = Config.from_args(args)
      add_server_client(children, config)
    end
  end

  defp add_server_clients(children, args) do
    Enum.reduce(args[:servers], children, fn {server_name, server_config}, c ->
      config =
        server_config
        |> Keyword.put(:name, server_name)
        |> Config.from_args()

      add_server_client(c, config)
    end)
  end

  defp add_server_client(children, config) do
    children ++ [{BTCRPC.Client, [config: config]}]
  end

  ####  public API ####

  @doc """
  Get the uptime of the bitcoin node
  """
  @spec get_uptime([rpc_opt()]) :: {:ok, pos_integer()}
  def get_uptime(opts \\ []) do
    opts
    |> Requests.uptime()
    |> Client.rpc_request(opts)
  end

  @doc """
  Get current block count
  """
  @spec get_block_count([rpc_opt()]) :: {:ok, pos_integer()}
  def get_block_count(opts \\ []) do
    opts
    |> Requests.get_blockcount()
    |> Client.rpc_request(opts)
  end
end
