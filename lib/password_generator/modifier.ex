defmodule PasswordGenerator.Modifier do
  alias PasswordGenerator.Random
  alias PasswordGenerator.Constant

  # ["@", "%", "+", "!", "#", "$", "?", "-", "_", "."]
  @legal_symbols Constant.legal_symbols()
  @legal_digits Constant.legal_digits()

  def use_separator(words, separator) do
    cond do
      separator === @legal_symbols ->
        Enum.map(words, fn word -> word <> Random.new(:symbol) end)
        |> Enum.join()

      separator === @legal_digits ->
        Enum.map(words, fn word -> word <> Random.new(:number) end)
        |> Enum.join()

      separator === nil ->
        Enum.join(words, "")

      true ->
        Enum.join(words, separator)
    end
  end

  def use_uppercase(set, true, count) do
    Enum.map_every(set, Enum.random(0..count), fn word -> String.upcase(word) end)
  end

  def use_uppercase(set, false, _count), do: set

  def include_symbols(set, true, string), do: set <> string
  def include_symbols(set, false, _string), do: set

  @spec include_numbers(any, boolean, any) :: any
  def include_numbers(set, true, string), do: set <> string
  def include_numbers(set, false, _string), do: set

  def append_number(string, true), do: string <> Random.new(:number)
  def append_number(string, false), do: string

  def append_symbol(string, true), do: string <> Random.new(:symbol)
  def append_symbol(string, false), do: string
end
