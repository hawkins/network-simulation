defmodule NetworkSimulation.Host do
  @doc """
  `listen` is the core loop of `Host`.

  The loop will run continuously, listening for new messages.

  ## Messages
  - `{:link, pid}`
    - Links the host at the given PID to this host
  - `{:get_neighbors, pid}`
    - Sends just the length of neighbors to the PID
    - (Just for debug)
  - default
    - Does nothing
  """
  def listen(state \\ %{address: "", neighbors: []}) do
    receive do
      {:link, neighbor_pid} ->
        IO.puts(state.address <> ": received new neighbor")
        listen(%{address: state.address, neighbors: [neighbor_pid | state.neighbors]})

      {:get_neighbors, requester} ->
        IO.puts(state.address <> ": neighbors: " <> to_string(length(state.neighbors)))
        send(requester, state.neighbors)
        listen(state)

      _ ->
        IO.puts(state.address <> ": unmatched message")
        listen(state)
    end
  end

  @doc """
  `start` is used to create a new `Host`.

  Returns a `PID` of the host
  """
  def start(address, neighbors \\ []) do
    spawn_link(fn ->
      listen(%{address: address, neighbors: neighbors})
    end)
  end
end

# TODO: Reimplement String.Chars for Host somehow
# defimpl String.Chars, for: NetworkSimulation.Host do
#   def to_string(term) do
#     term.address <> " (#{length(term.neighbors)} neighbors)"
#   end
# end
