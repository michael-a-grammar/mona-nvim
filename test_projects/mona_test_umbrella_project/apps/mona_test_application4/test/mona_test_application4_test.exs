defmodule MonaTestApplication4Test do
  use ExUnit.Case
  doctest MonaTestApplication4

  test "greets the world" do
    assert MonaTestApplication4.hello() == :world
  end
end
