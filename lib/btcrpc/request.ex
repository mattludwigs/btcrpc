defmodule BTCRPC.Request do
  @moduledoc """

  """

  @typedoc """

  """
  @type payload() :: map()

  @typedoc """

  """
  @type response_handler() :: (map() -> {:ok | :error, term()})

  @type t() :: %__MODULE__{
          payload: payload(),
          response_handler: response_handler()
        }

  defstruct [:payload, :response_handler]

  def new(payload, response_handler) do
    %__MODULE__{
      payload: payload,
      response_handler: response_handler
    }
  end

  def handle_response(request, response_body) do
    request.response_handler.(response_body)
  end
end
