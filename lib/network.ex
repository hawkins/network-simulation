defmodule NetworkSimulation.Network do
  @moduledoc """
  This module houses the control mechanisms for managing nodes including registration, communication, and partitioning
  """

  defstruct hosts: []

  @doc """
  Adds the given host to the given network
  """
  def register_host(%NetworkSimulation.Network{} = net, %NetworkSimulation.Host{} = host) do
    # TODO: Check that the host is not already in network
    net = %NetworkSimulation.Network{hosts: [host | net.hosts]}
    {:ok, net, host}
  end
end
