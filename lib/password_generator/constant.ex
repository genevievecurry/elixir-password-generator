defmodule PasswordGenerator.Constant do
  # @legal_symbols ["@", "%", "+", "!", "#", "$", "?", "-", "_", "."]
  @legal_symbols [64, 37, 43, 33, 35, 36, 63, 45, 95, 46]
  @legal_digits 0..9

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

  def separator_types, do: @separator_types
end
