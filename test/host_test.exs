defmodule NetworkSimulation.HostTest do
  use ExUnit.Case
  doctest NetworkSimulation.Host

  test "can be represented as a string" do
    host = %NetworkSimulation.Host{address: "104982"}
    assert to_string(host) == "104982 (0 neighbors)"
  end
end
