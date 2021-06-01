defmodule PasswordTest do
  use ExUnit.Case
  # doctest Password

  alias Password.Options
  alias Password.Analyzer

  @default_options %Options{}

  test "generates pin with default options" do
    pin = Password.pin()
    assert Regex.match?(~r/(\d){3,16}/, pin) == true
  end

  test "generates pin with legal length" do
    good_options = %Options{pin_length: @default_options.pin_length}
    pin = Password.pin(good_options)
    assert String.length(pin) == @default_options.pin_length
  end

  test "generates memorable password with default options" do
    memorable = Password.memorable()
    assert Regex.scan(~r/[[:alpha:]]+/u, memorable) |> Enum.count() == @default_options.word_count
  end

  test "generates random password with default options" do
    random = Password.random()
    assert String.length(random) == @default_options.character_count
  end

  test "analysis returns a score" do
    random = Password.random()
    assert is_integer(Analyzer.score(random)) == true
  end

  test "analysis returns a strength percentage" do
    strength = Password.random() |> Analyzer.score() |> Analyzer.strength()
    assert is_integer(strength) == true
    assert strength > 0 == true
    assert strength <= 100 == true
  end
end
