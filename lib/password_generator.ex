defmodule PasswordOpts do
  defstruct word_count: 3,
            character_count: 50,
            uppercase: true,
            separator_type: :digits,
            symbols: true,
            numbers: true
end

defmodule PasswordGenerator do
  @moduledoc """
  Documentation for `PasswordGenerator`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PasswordGenerator.generate()


  """

  require Integer
  use Agent

  # @legal_symbols ["@", "%", "+", "!", "#", "$", "?", "-", "_", "."]
  @legal_symbols [64, 37, 43, 33, 35, 36, 63, 45, 95, 46]
  @legal_digits [0..9]

  @separator_types %{
    none: "",
    hyphens: "-",
    underscores: "_",
    periods: ".",
    spaces: " ",
    digits: @legal_digits,
    symbols: @legal_symbols
  }

  @spec start_link() :: {:error, any} | {:ok, pid}
  def start_link() do
    Agent.start_link(fn -> word_list() end, name: __MODULE__)
  end

  @spec word_list :: [binary]
  def word_list() do
    # https://github.com/dwyl/english-words
    File.read!("priv/static/words_alpha.txt")
    |> String.split(~r/\n/)
  end

  @type options :: maybe_improper_list()

  @spec generate_random(
          atom
          | %{
              :character_count => non_neg_integer,
              :numbers => boolean,
              :symbols => boolean,
              optional(any) => any
            }
        ) :: binary
  def generate_random(options) do
    # Length 8-100
    # Options: Symbols / Numbers
    # Ex: xXNGyJHRhPMvzQcxoEtbcYrevaYrrHXeszDnyhx - no numbers, no symbols
    # Ex: c__-bMaJJq.!WT-GHwwHGvefVfwxDZW_gMsgqBk - symbols
    # Ex: 6Fu7P9KnZpaKkYVyZogTKNCVtsGfPs8JpYGcFZd - numbers
    # Ex: K9*z@cLETLXreigcgiq*mWPEQavCGojRTZnDhG2 - numbers and symbols

    (random_lowercase(options.character_count) <> random_uppercase(options.character_count))
    |> include_symbols(options.symbols, random_symbol(options.character_count))
    |> include_numbers(options.numbers, random_number(options.character_count))
    |> String.split("", trim: true)
    |> Enum.shuffle()
    |> Enum.take_random(options.character_count)
    |> Enum.join()
  end

  @spec generate_memorable(any) :: any
  def generate_memorable(options) do
    # How many words 3-15
    # Options: Capitalize / Full Words
    # Separator Type
    # sir-vaff-ghir
    # figurine-having-DROOPY
    # winy poseur compline
    # funerary.shift.MAXIMAL

    PasswordGenerator.start_link()

    separator = @separator_types[options.separator_type]

    IO.inspect(separator)

    random_word(options.word_count)
    |> use_uppercase(options.uppercase, options.word_count)
    |> use_separator(separator)
  end

  defp use_separator(words, separator) do
    cond do
      separator === @legal_symbols ->
        Enum.map(words, fn word -> word <> random_symbol() end)
        |> Enum.join()

      separator === @legal_digits ->
        Enum.map(words, fn word -> word <> random_number() end)
        |> Enum.join()

      true ->
        Enum.join(words, separator)
    end
  end

  defp use_uppercase(set, true, count) do
    Enum.map_every(set, Enum.random(0..count), fn word -> String.upcase(word) end)
  end

  defp use_uppercase(set, false, _count), do: set

  defp include_symbols(set, true, string), do: set <> string
  defp include_symbols(set, false, _string), do: set

  defp include_numbers(set, true, string), do: set <> string
  defp include_numbers(set, false, _string), do: set

  defp random_word(count),
    do: for(_int <- 1..count, do: Agent.get(__MODULE__, &Enum.random/1) |> String.trim())

  defp random_symbol(length \\ 1),
    do: for(_int <- 1..length, do: <<Enum.random(@legal_symbols)>>) |> Enum.join()

  defp random_uppercase(length),
    do: for(_int <- 1..length, do: <<Enum.random(65..90)>>) |> Enum.join()

  defp random_lowercase(length),
    do: for(_int <- 1..length, do: <<Enum.random(97..122)>>) |> Enum.join()

  defp random_number(length \\ 1) do
    for(_int <- 1..length, do: Enum.random(0..9)) |> Enum.join()
  end

  @type character_count :: integer
  @spec generate_pin(character_count) :: String.t()
  def generate_pin(character_count) do
    cond do
      character_count >= 3 and character_count <= 12 ->
        random_number(character_count)

      character_count < 3 ->
        IO.puts("Pin length too short. Try again...")
        pin_prompt()

      character_count > 12 ->
        IO.puts("Pin length too long. Try again...")
        pin_prompt()

      true ->
        pin_prompt()
    end
  end

  def start do
    IO.puts("What type of password do you need?\n")
    IO.puts("[1] - Random\n[2] - Memorable\n[3] - Pin\n")
    password_type = IO.gets("Type 1, 2 or 3 and press return\n")

    case password_type do
      "1\n" -> random_prompt()
      "2\n" -> memorable_prompt()
      "3\n" -> pin_prompt()
    end
  end

  # none: "",
  # hyphens: "-",
  # underscores: "_",
  # periods: ".",
  # spaces: "_",
  # digits: [0..9],
  # symbols: @legal_symbols

  def memorable_prompt do
    if IO.gets("Use defaults? Y/N\n") |> bool_input() do
      generate_memorable(%PasswordOpts{})
    else
      %PasswordOpts{
        word_count: IO.gets("How many words? Between 3 - 15\n") |> length_input(),
        uppercase: IO.gets("Include uppercase? Y/N\n") |> bool_input(),
        separator_type: IO.gets("What type of separator?\n") |> separator_input()
      }
      |> generate_memorable()
    end
  end

  def random_prompt do
    if IO.gets("Use defaults? Y/N\n") |> bool_input() do
      generate_random(%PasswordOpts{})
    else
      %PasswordOpts{
        character_count: IO.gets("Select password length between 8 - 100:\n") |> length_input(),
        symbols: IO.gets("Include symbols? Y/N\n") |> bool_input(),
        numbers: IO.gets("Include numbers? Y/N\n") |> bool_input()
      }
      |> generate_random()
    end
  end

  def pin_prompt do
    IO.gets("Select pin length between 3 - 12:\n") |> length_input() |> generate_pin()
  end

  defp length_input(value) when is_bitstring(value) do
    try do
      value |> String.trim() |> String.to_integer()
    rescue
      _e in ArgumentError -> exit("Invalid length.")
    end
  end

  defp length_input(value) when is_integer(value), do: value

  defp separator_input(value) when is_bitstring(value) do
    value |> String.trim() |> String.to_atom()
  end

  defp bool_input(value) when is_bitstring(value) do
    Enum.member?(["y\n", "yes\n", "\n"], String.downcase(value))
  end

  defp bool_input(value) when is_boolean(value), do: value
end
