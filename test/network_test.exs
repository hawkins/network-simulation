defmodule NetworkSimulation.NetworkTest do
  use ExUnit.Case
  doctest NetworkSimulation.Network

  test "can register new hosts" do
    net = %NetworkSimulation.Network{}
    assert length(net.hosts) == 0
    host = %NetworkSimulation.Host{address: "A"}
    {status, net, host} = NetworkSimulation.Network.register_host(net, host)
    assert status == :ok
    assert length(net.hosts) == 1
  end
end
