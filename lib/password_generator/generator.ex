defmodule PasswordGenerator.Generator do
  alias PasswordGenerator.Constant
  alias PasswordGenerator.Random
  alias PasswordGenerator.Modifier
  alias PasswordGenerator.Validator

  @separator_types Constant.separator_types()

  @spec random(
          atom
          | %{
              :character_count => non_neg_integer,
              :numbers => boolean,
              :symbols => boolean,
              optional(any) => any
            }
        ) :: binary
  def random(options) do
    # Length 8-100
    # Options: Symbols / Numbers
    # Ex: xXNGyJHRhPMvzQcxoEtbcYrevaYrrHXeszDnyhx - no numbers, no symbols
    # Ex: c__-bMaJJq.!WT-GHwwHGvefVfwxDZW_gMsgqBk - symbols
    # Ex: 6Fu7P9KnZpaKkYVyZogTKNCVtsGfPs8JpYGcFZd - numbers
    # Ex: K9*z@cLETLXreigcgiq*mWPEQavCGojRTZnDhG2 - numbers and symbols

    (Random.new(:lowercase, options.character_count) <>
       Random.new(:uppercase, options.character_count))
    |> Modifier.include_symbols(options.symbols, Random.new(:symbol, options.character_count))
    |> Modifier.include_numbers(options.numbers, Random.new(:number, options.character_count))
    |> String.split("", trim: true)
    |> Enum.shuffle()
    |> Enum.take_random(options.character_count)
    |> Enum.join()
  end

  @spec memorable(
          atom
          | %{
              :separator_type => atom(),
              :uppercase => boolean,
              :word_count => non_neg_integer,
              optional(any) => any
            }
        ) :: binary
  def memorable(options) do
    # How many words 3-15
    # Options: Capitalize / Full Words
    # Separator Type
    # sir-vaff-ghir
    # figurine-having-DROOPY
    # winy poseur compline
    # funerary.shift.MAXIMAL

    Random.start_link()

    separator = @separator_types[options.separator_type]

    Random.new(:word, options.word_count)
    |> Modifier.use_uppercase(options.uppercase, options.word_count)
    |> Modifier.use_separator(separator)
  end

  @type character_count :: integer
  @spec pin(atom | %{:character_count => integer, optional(any) => any}) :: binary
  def pin(options) do
    Validator.check_length_input(options.character_count, 3, 16)
    |> then(&Random.new(:number, &1))
  end
end
