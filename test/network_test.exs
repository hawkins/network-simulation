defmodule NetworkSimulation.NetworkTest do
  use ExUnit.Case
  doctest NetworkSimulation.Network

  alias NetworkSimulation.Network, as: Network

  test "can register new hosts" do
    net = %Network{}
    assert length(net.pids) == 0

    {:ok, net, _} = Network.register_host(net, "A")

    assert length(net.pids) == 1
  end

  test "can't register duplicate hosts" do
    address = "A"
    {:ok, net, _} = Network.register_host(%Network{}, address)

    {:address_unavailable, _, _} = Network.register_host(net, address)
  end

  test "can decide neighbors" do
    net = %Network{}
    {:ok, net, _} = Network.register_host(net, "A")
    {:ok, net, _} = Network.register_host(net, "B")
    {:ok, net, _} = Network.register_host(net, "C")

    assert length(Network.decide_neighbors(net, :random)) > 0
    assert length(Network.decide_neighbors(net, :none)) == 0
  end

  test "can register random neighbors" do
    net = %Network{}

    {:ok, net, pidA} = Network.register_host(net, "A")

    {:ok, _, pidB} = Network.register_host(net, "B")

    send(pidB, {:get_neighbors, self()})
    send(pidA, {:get_neighbors, self()})

    assert_receive neighbors, 500
    assert length(neighbors) == 1
    assert_receive neighbors, 500
    assert length(neighbors) == 1
  end

  test "can add a disconnected host" do
    net = %Network{}

    {:ok, net, pidA} = Network.register_host(net, "A")

    {:ok, _, pidB} = Network.register_host(net, "B", :none)

    send(pidB, {:get_neighbors, self()})
    send(pidA, {:get_neighbors, self()})

    assert_receive neighbors, 500
    assert length(neighbors) == 0
    assert_receive neighbors, 500
    assert length(neighbors) == 0
  end
end
