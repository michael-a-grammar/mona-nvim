defmodule MonaTestApplication2Test do
  use ExUnit.Case
  doctest MonaTestApplication2

  test "greets the world" do
    assert MonaTestApplication2.hello() == :world
  end
end
