defmodule PasswordGeneratorTest do
  use ExUnit.Case
  # doctest PasswordGenerator

  @min 1
  @max 16

  import PasswordOpts

  test "generates random pin with default options" do
    pin = PasswordGenerator.pin()
    assert Regex.match?(~r/(\d){3,16}/, pin) == true
  end

  @tag :pending
  test "generates random pin with too many characters throws error" do
    bad_input = %PasswordOpts{character_count: 122}
    assert :error, PasswordGenerator.pin(bad_input)
  end
end
