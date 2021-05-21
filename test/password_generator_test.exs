defmodule PasswordGeneratorTest do
  use ExUnit.Case
  doctest PasswordGenerator

  test "greets the world" do
    assert PasswordGenerator.hello() == :world
  end
end
