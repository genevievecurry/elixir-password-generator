defmodule Password.Constant do
  # @legal_symbols ["!", "#", "$", "%", "+","-", ".","?", "@", "_"]
  @legal_symbols [33, 35, 36, 37, 43, 45, 46, 63, 64, 95]
  @legal_digits 0..9

  @legal_length %{
    pin: [{:min, 3}, {:max, 16}],
    memorable: [{:min, 3}, {:max, 15}],
    random: [{:min, 8}, {:max, 100}]
  }

  @separator_types %{
    none: "",
    hyphens: "-",
    underscores: "_",
    periods: ".",
    spaces: " ",
    digits: @legal_digits,
    symbols: @legal_symbols
  }

  def legal_symbols, do: @legal_symbols

  def legal_digits, do: @legal_digits

  def legal_length, do: @legal_length

  def separator_types, do: @separator_types
end
