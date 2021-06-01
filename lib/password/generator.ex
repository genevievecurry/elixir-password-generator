defmodule Password.Generator do
  alias Password.Constant
  alias Password.Random
  alias Password.Modifier
  alias Password.Validator

  @separator_types Constant.separator_types()
  @legal_length Constant.legal_length()

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
    Random.start_link()
    separator = @separator_types[options.separator_type]

    Random.new(:word, options.word_count)
    |> Modifier.use_uppercase(options.uppercase, options.word_count)
    |> Modifier.use_separator(separator)
    |> Modifier.append_number(options.numbers)
    |> Modifier.append_symbol(options.symbols)
  end

  def pin(options) do
    Validator.check_length_input(
      options.pin_length,
      @legal_length.pin[:min],
      @legal_length.pin[:max]
    )
    |> then(&Random.new(:number, &1))
  end
end
