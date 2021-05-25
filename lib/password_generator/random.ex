defmodule PasswordGenerator.Random do
  use Agent
  require PasswordGenerator.Constant

  # ["@", "%", "+", "!", "#", "$", "?", "-", "_", "."]
  @legal_symbols PasswordGenerator.Constant.legal_symbols()
  @legal_digits PasswordGenerator.Constant.legal_digits()

  @spec start_word_link() :: {:error, any} | {:ok, pid}
  def start_word_link() do
    Agent.start_link(fn -> word_list() end, name: __MODULE__)
  end

  @spec word_list :: [binary]
  def word_list() do
    # https://github.com/dwyl/english-words
    File.read!("priv/static/words_alpha.txt")
    |> String.split(~r/\n/)
  end

  @spec r_word(integer) :: list
  def r_word(count),
    do: for(_int <- 1..count, do: Agent.get(__MODULE__, &Enum.random/1) |> String.trim())

  @spec r_symbol(integer) :: binary
  def r_symbol(length \\ 1),
    do: for(_int <- 1..length, do: <<Enum.random(@legal_symbols)>>) |> Enum.join()

  def r_number(length \\ 1)

  @spec r_number(integer) :: binary
  def r_number(length) when is_integer(length) do
    for(_int <- 1..length, do: Enum.random(@legal_digits)) |> Enum.join()
  end

  def r_number(length) when length == :error, do: :error

  @spec r_uppercase(integer) :: binary
  def r_uppercase(length),
    do: for(_int <- 1..length, do: <<Enum.random(65..90)>>) |> Enum.join()

  @spec r_lowercase(integer) :: binary
  def r_lowercase(length),
    do: for(_int <- 1..length, do: <<Enum.random(97..122)>>) |> Enum.join()
end
