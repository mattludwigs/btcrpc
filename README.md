# BTCRPC

Work in progress BTCRPC client.

## Quick start

To use `BTCRPC` in an IEx session:

```elixir
iex> {:ok, _pid} = BTCRPC.start_link(hostname: "localhost", port: 8332, user: "Satoshi", password: "hodl")
iex> {:ok, uptime} = BTCRPC.uptime()
```

## Usage in an Elixir application

If you're only talking to a single bitcoin RPC server:

```elixir
defmodule MyApp.Application do
  use Application

  @impl true
  def start_link(_type, _args) do
    children = [
      {BTCRPC, hostname: "localhost", port: 8332, user: "Satoshi", password: "hodl"}
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# later in your code

uptime = BTCRPC.uptime()
```

However, `BTCRPC` allows for communication to many servers. Just like above you
would add `BTCRPC` to your supervision tree but the configuration a little
different.

```elixir
defmodule MyApp.Application do
  use Application

  @impl true
  def start_link(_type, _args) do
    rpc_servers = %{
      "btc1" => [hostname: "hostname", port: 8332, user: "user", password: "password"],
      "btc2" => [hostname: "hostname2", port: 8332, user: "user", password: "password"]
    }

    children = [
      {BTCRPC, servers: rpc_servers}
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

# later in your code, you will have to specify which server
# to use
uptime = BTCRPC.uptime(server: "btc1")

uptime = BTCRPC.uptime(server: "btc2")
```
