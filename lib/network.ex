defmodule NetworkSimulation.Network do
  @moduledoc """
  This module houses the control mechanisms for managing nodes including registration, communication, and partitioning
  """

  defstruct hosts: []

  @doc """
  Adds the given host to the given network
  """
  def register_host(%NetworkSimulation.Network{} = net, %NetworkSimulation.Host{} = host) do
    # Check that the host is not already in network
    already_registered =
      Enum.any?(net.hosts, fn registered_host ->
        registered_host.address == host.address
      end)

    if already_registered do
      {:address_unavailable, net, host}
    else
      # TODO: Assign a few neighbors
      net = %NetworkSimulation.Network{hosts: [host | net.hosts]}
      {:ok, net, host}
    end
  end
end
