defmodule PasswordGenerator.Prompt do
  alias PasswordGenerator.Validator
  alias PasswordGenerator.Generator
  alias PasswordGenerator.Options

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

  def memorable_prompt do
    if IO.gets("Use defaults? Y/N\n") |> Validator.bool_input() do
      Generator.memorable(%Options{})
    else
      %Options{
        word_count:
          IO.gets("How many words? Between 3 - 15\n") |> Validator.check_length_input(3, 15),
        uppercase: IO.gets("Include uppercase? Y/N\n") |> Validator.bool_input(),
        separator_type: IO.gets("What type of separator?\n") |> Validator.separator_input()
      }
      |> Generator.memorable()
    end
  end

  def random_prompt do
    if IO.gets("Use defaults? Y/N\n") |> Validator.bool_input() do
      Generator.random(%Options{})
    else
      %Options{
        character_count:
          IO.gets("Select password length between 8 - 100:\n")
          |> Validator.check_length_input(8, 100),
        symbols: IO.gets("Include symbols? Y/N\n") |> Validator.bool_input(),
        numbers: IO.gets("Include numbers? Y/N\n") |> Validator.bool_input()
      }
      |> Generator.random()
    end
  end

  def pin_prompt do
    if IO.gets("Use defaults? Y/N\n") |> Validator.bool_input() do
      Generator.pin(%Options{})
    else
      %Options{
        character_count:
          IO.gets("Select pin length between 3 - 16:\n")
          |> Validator.check_length_input(3, 16)
      }
      |> Generator.pin()
    end
  end
end
