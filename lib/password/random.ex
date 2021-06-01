defmodule Password.Random do
  use Agent
  alias Password.Constant

  # ["@", "%", "+", "!", "#", "$", "?", "-", "_", "."]
  @legal_symbols Constant.legal_symbols()
  @legal_digits Constant.legal_digits()
  # https://github.com/dwyl/english-words
  @word_list File.read!("priv/static/words_alpha.txt") |> String.split(~r/\n/)

  @spec start_link() :: {:error, any} | {:ok, pid}
  def start_link() do
    Agent.start_link(fn -> word_list() end, name: __MODULE__)
  end

  @spec word_list :: [binary]
  def word_list() do
    @word_list
  end

  @spec new(atom, integer) :: list
  def new(type, length \\ 1)

  def new(:word, count) do
    for _int <- 1..count do
      __MODULE__
      |> Agent.get(&Enum.random/1)
      |> String.trim()
    end
  end

  def new(:symbol, length) do
    for _int <- 1..length do
      <<Enum.random(@legal_symbols)>>
    end
    |> Enum.join()
  end

  def new(:number, length) when is_integer(length) do
    for _int <- 1..length do
      Enum.random(@legal_digits)
    end
    |> Enum.join()
  end

  def new(:number, length) when length == :error, do: :error

  def new(:uppercase, length) do
    for _int <- 1..length do
      <<Enum.random(65..90)>>
    end
    |> Enum.join()
  end

  def new(:lowercase, length) do
    for _int <- 1..length do
      <<Enum.random(97..122)>>
    end
    |> Enum.join()
  end
end
