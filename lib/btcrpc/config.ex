defmodule BTCRPC.Config do
  @moduledoc false

  alias BTCRPC.Client.DefaultAdapter

  defstruct [:hostname, :port, :user, :password, :name, :adapter]

  @type args() :: BTCRPC.btc_rpc_args() | [name: String.t()]

  def from_args(args) do
    %__MODULE__{
      hostname: gethostname(args),
      port: Keyword.fetch!(args, :port),
      user: Keyword.fetch!(args, :user),
      password: Keyword.fetch!(args, :password),
      name: args[:name],
      adapter: args[:adapter] || DefaultAdapter
    }
  end

  defp gethostname(args) do
    case Keyword.get(args, :hostname) do
      hostname when hostname in [nil, "localhost"] ->
        "http://localhost"

      hostname ->
        hostname
    end
  end
end
