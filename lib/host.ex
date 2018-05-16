defmodule NetworkSimulation.Host do
  @enforce_keys [:address]
  defstruct address: :address, neighbors: []
end

defimpl String.Chars, for: NetworkSimulation.Host do
  def to_string(term) do
    term.address <> " (#{length(term.neighbors)} neighbors)"
  end
end
