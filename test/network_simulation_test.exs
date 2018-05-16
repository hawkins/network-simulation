defmodule NetworkSimulationTest do
  use ExUnit.Case
  doctest NetworkSimulation

  test "greets the world" do
    assert NetworkSimulation.hello() == :world
  end
end
