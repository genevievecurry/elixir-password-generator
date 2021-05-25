defmodule PasswordGenerator.Generator do
  require PasswordGenerator.Constant
  require PasswordGenerator.Modifier
  require PasswordGenerator.Validator
  alias PasswordGenerator.Constant, as: Constant
  alias PasswordGenerator.Random, as: Random
  alias PasswordGenerator.Modifier, as: Modifier
  alias PasswordGenerator.Validator, as: Validator

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

    (Random.r_lowercase(options.character_count) <> Random.r_uppercase(options.character_count))
    |> Modifier.include_symbols(options.symbols, Random.r_symbol(options.character_count))
    |> Modifier.include_numbers(options.numbers, Random.r_number(options.character_count))
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

    Random.start_word_link()

    separator = @separator_types[options.separator_type]

    Random.r_word(options.word_count)
    |> Modifier.use_uppercase(options.uppercase, options.word_count)
    |> Modifier.use_separator(separator)
  end

  @type character_count :: integer
  @spec pin(atom | %{:character_count => integer, optional(any) => any}) :: binary
  def pin(options) do
    Validator.check_length_input(options.character_count, 3, 16)
    |> Random.r_number()
  end
end
