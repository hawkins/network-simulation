defmodule NetworkSimulation.Network do
  @moduledoc """
  This module houses the control mechanisms for managing nodes including registration, communication, and partitioning
  """

  defstruct hosts: []

  alias NetworkSimulation.Network, as: Network
  alias NetworkSimulation.Host, as: Host

  @doc """
  Adds the given host to the given network, registering neighbors as well
  """
  def register_host(%Network{} = net, %Host{} = host, connecting_heuristic \\ :random) do
    # Check that the host is not already in network
    already_registered = Enum.any?(net.hosts, &(&1.address == host.address))

    if already_registered do
      {:address_unavailable, net, host}
    else
      # Assign a few neighbors
      neighboring_addresses = decide_neighbors(net, connecting_heuristic)

      neighbors =
        Enum.filter(net.hosts, fn potential_neighbor ->
          Enum.any?(neighboring_addresses, &(&1 == potential_neighbor.address))
        end)

      # Add neighbors to this host
      host = %Host{neighbors: neighbors, address: host.address}

      # Update prior hosts with their new neighbor
      neighbors =
        Enum.map(neighbors, &%Host{address: &1.address, neighbors: [host | &1.neighbors]})

      # Update existing hosts in the net
      hosts =
        Enum.map(net.hosts, fn h ->
          if Enum.member?(neighboring_addresses, h.address) do
            Enum.find(neighbors, &(&1.address == h.address))
          else
            h
          end
        end)

      # Finally update the net
      net = %Network{hosts: [host | hosts]}
      {:ok, net, host}
    end
  end

  @doc """
  Given a network and a heuristic, this function will decide
  which neighbors should be assigned to the new host.

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
      # Get all node addresses
      addresses = Enum.map(net.hosts, & &1.address)

      case strategy do
        :random ->
          # Decide how many neighbors we can have
          count = :rand.uniform(3)

          count =
            if count > length(addresses) do
              length(addresses)
            else
              count
            end

          # Decide which neighbors we have
          Enum.take_random(addresses, count)
      end
    end
  end
end
