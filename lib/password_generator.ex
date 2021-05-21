defmodule PasswordOpts do
  defstruct word_count: 3,
            character_count: 50,
            upcase: false,
            words: false,
            separator_type: :none,
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

  # @legal_symbols ["@", "%", "+", "!", "#", "$", "?", "-", "_", "."]
  @legal_symbols [64, 37, 43, 33, 35, 36, 63, 45, 95, 46]

  @separator_types %{
    none: "",
    hyphens: "-",
    underscores: "_",
    periods: ".",
    spaces: "_",
    digits: [0..9],
    special_characters: @legal_symbols
  }

  @spec memorable :: String.t()
  def memorable do
    # How many words 3-15
    # Options: Capitalize / Full Words
    # Separator Type
  end

  @type options :: maybe_improper_list()
  @spec generate_random(options) :: String.t()
  def generate_random(options) do
    # Length 8-100
    # Options: Symbols / Numbers
    # Ex: xXNGyJHRhPMvzQcxoEtbcYrevaYrrHXeszDnyhx - no numbers, no symbols
    # Ex: c__-bMaJJq.!WT-GHwwHGvefVfwxDZW_gMsgqBk - symbols
    # Ex: 6Fu7P9KnZpaKkYVyZogTKNCVtsGfPs8JpYGcFZd - numbers
    # Ex: K9*z@cLETLXreigcgiq*mWPEQavCGojRTZnDhG2 - numbers and symbols

    lowercase_stream =
      Stream.unfold(random_lowercase(options.character_count), &String.next_codepoint/1)

    uppercase_stream =
      Stream.unfold(random_uppercase(options.character_count), &String.next_codepoint/1)

    symbol_stream =
      Stream.unfold(random_symbol(options.character_count), &String.next_codepoint/1)

    number_stream =
      Stream.unfold(random_number(options.character_count), &String.next_codepoint/1)

    Enum.concat(lowercase_stream, uppercase_stream)
    |> include_symbols(options.symbols, symbol_stream)
    |> include_numbers(options.numbers, number_stream)
    |> Enum.shuffle()
    |> Enum.take_random(options.character_count)
    |> Enum.join()
  end

  defp include_symbols(set, true, symbol_stream), do: Enum.concat(set, symbol_stream)
  defp include_symbols(set, false, _symbol_stream), do: set

  defp include_numbers(set, true, number_stream), do: Enum.concat(set, number_stream)
  defp include_numbers(set, false, _number_stream), do: set

  defp random_symbol(length \\ 1),
    do: for(_int <- 1..length, do: <<Enum.random(@legal_symbols)>>) |> Enum.join()

  defp random_uppercase(length \\ 1),
    do: for(_int <- 1..length, do: <<Enum.random(65..90)>>) |> Enum.join()

  defp random_lowercase(length \\ 1),
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

  def memorable_prompt do
    nil
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

  defp bool_input(value) when is_bitstring(value) do
    Enum.member?(["y\n", "yes\n", "\n"], String.downcase(value))
  end

  defp bool_input(value) when is_boolean(value), do: value
end
