defmodule BTCRPCTest do
  use ExUnit.Case
  doctest BTCRPC

  test "greets the world" do
    assert BTCRPC.hello() == :world
  end
end
