defmodule NetworkSimulation.NetworkTest do
  use ExUnit.Case
  doctest NetworkSimulation.Network

  alias NetworkSimulation.Network, as: Network
  alias NetworkSimulation.Host, as: Host

  test "can register new hosts" do
    net = %Network{}
    assert length(net.hosts) == 0

    {status, net, _} = Network.register_host(net, %Host{address: "A"})

    assert status == :ok
    assert length(net.hosts) == 1
  end

  test "can't register duplicate hosts" do
    host = %Host{address: "A"}
    {status, net, _} = Network.register_host(%Network{}, host)
    assert status == :ok

    {status, _, _} = Network.register_host(net, host)
    assert status == :address_unavailable
  end

  test "can decide neighbors" do
    net = %Network{
      hosts: [
        %Host{address: "A"},
        %Host{address: "B"},
        %Host{address: "C"}
      ]
    }

    assert length(Network.decide_neighbors(net, :random)) > 0
    assert length(Network.decide_neighbors(net, :none)) == 0
  end

  test "can register random neighbors" do
    net = %Network{}

    {status, net, _} = Network.register_host(net, %Host{address: "A"})

    assert status == :ok

    {status, net, _} = Network.register_host(net, %Host{address: "B"})

    assert status == :ok
    Enum.map(net.hosts, &assert(length(&1.neighbors) == 1))
  end

  test "can add a disconnected host" do
    net = %Network{}

    {status, net, _} = Network.register_host(net, %Host{address: "A"})

    assert status == :ok

    {status, net, _} = Network.register_host(net, %Host{address: "B"}, :none)

    assert status == :ok
    Enum.map(net.hosts, &assert(length(&1.neighbors) == 0))
  end
end
