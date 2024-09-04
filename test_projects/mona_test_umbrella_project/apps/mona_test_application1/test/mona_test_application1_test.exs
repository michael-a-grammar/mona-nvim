defmodule MonaTestApplication1Test do
  use ExUnit.Case
  doctest MonaTestApplication1

  test "greets the world" do
    assert MonaTestApplication1.hello() == :world
  end
end
