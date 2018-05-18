defmodule NetworkSimulation.Network do
  @moduledoc """
  This module houses the control mechanisms for managing nodes including registration, communication, and partitioning
  """

  defstruct addresses: [], pids: []

  alias NetworkSimulation.Network, as: Network
  alias NetworkSimulation.Host, as: Host

  @doc """
  Registers a host for the given address to the given network, registering neighbors as well
  """
  def register_host(%Network{} = net, address, connecting_heuristic \\ :random) do
    # Check that the host is not already in network
    if Enum.member?(net.addresses, address) do
      {:address_unavailable, net, address}
    else
      neighbors = decide_neighbors(net, connecting_heuristic)

      host = Host.start(address, neighbors)

      # Link this host with its neighbors
      Enum.each(neighbors, fn pid ->
        IO.puts("Linking nodes")
        send(pid, {:link, host})
      end)

      # Finally update the net
      net = %Network{pids: [host | net.pids], addresses: [address | net.addresses]}

      {:ok, net, host}
    end
  end

  @doc """
  Given a network and a heuristic, this function will decide
  which neighbors should be assigned to the new host.

  Returns a list of PIDs.

  ## Heuristics

  The currently allowed heuristics are:

  - `:random`
    - Randomly picks up to 3 hosts to neighbor
  - `:none`
    - Neighbors no hosts, creating a new partition
  """
  def decide_neighbors(%Network{} = net, strategy) do
    if strategy == :none do
      []
    else
      case strategy do
        :random ->
          # Decide how many neighbors we can have
          count = :rand.uniform(3)

          count =
            if count > length(net.pids) do
              length(net.pids)
            else
              count
            end

          # Decide which neighbors we have
          Enum.take_random(net.pids, count)
      end
    end
  end
end
