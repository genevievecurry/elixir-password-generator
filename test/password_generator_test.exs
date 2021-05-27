defmodule PasswordGeneratorTest do
  use ExUnit.Case
  # doctest PasswordGenerator

  alias PasswordGenerator.Options
  alias PasswordGenerator.Constant

  @default_options %Options{}
  @legal_length Constant.legal_length()

  test "generates pin with default options" do
    pin = PasswordGenerator.pin()
    assert Regex.match?(~r/(\d){3,16}/, pin) == true
  end

  test "generates pin with legal length" do
    good_options = %Options{pin_length: @default_options.pin_length}
    pin = PasswordGenerator.pin(good_options)
    assert String.length(pin) == @default_options.pin_length
  end

  test "generates memorable password with default options" do
    memorable = PasswordGenerator.memorable()
    assert Regex.scan(~r/[[:alpha:]]+/u, memorable) |> Enum.count() == @default_options.word_count
  end

  test "generates random password with default options" do
    random = PasswordGenerator.random()
    assert String.length(random) == @default_options.character_count
  end
end
