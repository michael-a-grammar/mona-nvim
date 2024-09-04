defmodule MonaTestProjectTest do
  use ExUnit.Case
  doctest MonaTestProject

  test "greets the world" do
    assert MonaTestProject.hello() == :world
  end
end
