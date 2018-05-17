defmodule NetworkSimulation.NetworkTest do
  use ExUnit.Case
  doctest NetworkSimulation.Network

  test "can register new hosts" do
    net = %NetworkSimulation.Network{}
    assert length(net.hosts) == 0

    {status, net, _} =
      NetworkSimulation.Network.register_host(net, %NetworkSimulation.Host{address: "A"})

    assert status == :ok
    assert length(net.hosts) == 1
  end

  test "can't register duplicate hosts" do
    host = %NetworkSimulation.Host{address: "A"}
    {status, net, _} = NetworkSimulation.Network.register_host(%NetworkSimulation.Network{}, host)
    assert status == :ok

    {status, _, _} = NetworkSimulation.Network.register_host(net, host)
    assert status == :address_unavailable
  end

  test "can decide neighbors" do
    net = %NetworkSimulation.Network{
      hosts: [
        %NetworkSimulation.Host{address: "A"},
        %NetworkSimulation.Host{address: "B"},
        %NetworkSimulation.Host{address: "C"}
      ]
    }

    assert length(NetworkSimulation.Network.decide_neighbors(net, :random)) > 0
    assert length(NetworkSimulation.Network.decide_neighbors(net, :none)) == 0
  end

  test "can register random neighbors" do
    net = %NetworkSimulation.Network{}

    {status, net, _} =
      NetworkSimulation.Network.register_host(net, %NetworkSimulation.Host{address: "A"})

    assert status == :ok

    {status, net, _} =
      NetworkSimulation.Network.register_host(net, %NetworkSimulation.Host{address: "B"})

    assert status == :ok
    Enum.map(net.hosts, &assert(length(&1.neighbors) == 1))
  end

  test "can add a disconnected host" do
    net = %NetworkSimulation.Network{}

    {status, net, _} =
      NetworkSimulation.Network.register_host(net, %NetworkSimulation.Host{address: "A"})

    assert status == :ok

    {status, net, _} =
      NetworkSimulation.Network.register_host(net, %NetworkSimulation.Host{address: "B"}, :none)

    assert status == :ok
    Enum.map(net.hosts, &assert(length(&1.neighbors) == 0))
  end
end
