defmodule MonaTestProject.TestModules.Module1 do
  alias MonaTestProject.TestModules.Module3
  alias MonaTestProject.TestModules.Module4, as: Mod4

  def test_function1(parameter) do
    MonaTestProject.TestModules.Module2.test_function2(:test)

    Module3.test_function3(:test)

    Mod4.test_function4(:test)

    IO.inspect(parameter, label: "Parameter")
  end
end
