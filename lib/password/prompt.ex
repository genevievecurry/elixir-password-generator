defmodule Password.Prompt do
  alias Password.Validator
  alias Password.Generator
  alias Password.Options
  alias Password.Constant

  @legal_length Constant.legal_length()

  @spec start(any) :: binary
  def start(_input \\ nil) do
    IO.puts("What type of password do you need?\n")
    IO.puts("[1] - Random\n[2] - Memorable\n[3] - Pin\n")
    password_type = IO.gets("Type 1, 2 or 3 and press return\n")

    start_selection(password_type)
  end

  def start_selection(password_type) do
    case password_type do
      "1\n" -> random_prompt()
      "2\n" -> memorable_prompt()
      "3\n" -> pin_prompt()
      _ -> IO.puts("Oops, that is not a valid option!") |> start()
    end
  end

  def random_prompt do
    min = @legal_length.random[:min]
    max = @legal_length.random[:max]

    if IO.gets("Use defaults? Y/N\n") |> Validator.bool_input() do
      Generator.random(%Options{})
    else
      %Options{
        character_count:
          IO.gets("Select password length between #{min} - #{max}:\n")
          |> Validator.check_length_input(min, max),
        symbols: IO.gets("Include symbols? Y/N\n") |> Validator.bool_input(),
        numbers: IO.gets("Include numbers? Y/N\n") |> Validator.bool_input()
      }
      |> Generator.random()
    end
  end

  def memorable_prompt do
    min = @legal_length.memorable[:min]
    max = @legal_length.memorable[:max]

    if IO.gets("Use defaults? Y/N\n") |> Validator.bool_input() do
      Generator.memorable(%Options{})
    else
      %Options{
        word_count:
          IO.gets("How many words? Between #{min} - #{max}\n")
          |> Validator.check_length_input(min, max),
        uppercase: IO.gets("Include uppercase? Y/N\n") |> Validator.bool_input(),
        separator_type:
          IO.gets("What type of separator? (symbols, hypens, periods, etc)\n")
          |> Validator.separator_input(),
        numbers: IO.gets("Append number? Y/N\n") |> Validator.bool_input(),
        symbols: IO.gets("Append symbol? Y/N\n") |> Validator.bool_input()
      }
      |> Generator.memorable()
    end
  end

  def pin_prompt do
    min = @legal_length.pin[:min]
    max = @legal_length.pin[:max]

    if IO.gets("Use defaults? Y/N\n") |> Validator.bool_input() do
      Generator.pin(%Options{})
    else
      %Options{
        pin_length:
          IO.gets("Select pin length between #{min} - #{max}:\n")
          |> Validator.check_length_input(min, max)
      }
      |> Generator.pin()
    end
  end
end
