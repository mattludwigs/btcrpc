defmodule BTCRPC.Client.Adapter do
  @moduledoc """
  Behaviour for plug
  """

  alias BTCRPC.{Config, Request}

  @doc """
  Initialize the adapter with the configuration
  """
  @callback init(Config.t()) :: {:ok, state :: term()} | {:error, term()}

  @doc """
  Send a RPC request
  """
  @callback send_rpc_request(Request.t(), state :: term()) ::
              {:ok | :error, term(), state :: term()}
end
