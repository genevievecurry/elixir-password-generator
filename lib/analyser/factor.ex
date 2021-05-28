defmodule Analyser.Factor do
  def check(type, password)

  def check(:length, password) do
    {:add, String.length(password) * 4}
  end

  def check(:uppercase, password) do
    length = String.length(password)
    count = Regex.scan(~r/[[:upper:]]/u, password) |> Enum.count()
    {:add, (length - count) * 2}
  end

  def check(:lowercase, password) do
    length = String.length(password)
    count = Regex.scan(~r/[[:lower:]]/u, password) |> Enum.count()
    {:add, (length - count) * 2}
  end

  def check(:numbers, password) do
    count = Regex.scan(~r/[[:digit:]]/u, password) |> Enum.count()
    {:add, count * 4}
  end

  def check(:symbols, password) do
    count = Regex.scan(~r/[!#$%+-.?@_]/u, password) |> Enum.count()
    {:add, count * 6}
  end

  def check(:middle, _password) do
    # TODO
  end

  def check(:minimum_req, password) do
    # At least 1 number, 1 special character, mix of upper and lower characters, between 8-100 characters long
    strong_password_regex = ~r/((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W]).{8,100})/u

    cond do
      Regex.match?(strong_password_regex, password) == true -> {:add, 10}
      true -> {:add, 0}
    end
  end

  def check(:letters_only, password) do
    length = String.length(password)
    count = Regex.scan(~r/[[:alpha:]]/u, password) |> Enum.count()

    cond do
      length == count -> {:subtract, count}
      true -> {:subtract, 0}
    end
  end

  def check(:numbers_only, password) do
    length = String.length(password)
    count = Regex.scan(~r/[[:digit:]]/u, password) |> Enum.count()

    cond do
      length == count -> {:subtract, count}
      true -> {:subtract, 0}
    end
  end

  def check(:repeat_char, password) do
    # TODO
    _length = String.length(password)

    _repeated =
      String.split(password, "", trim: true)
      |> IO.inspect()
      |> Enum.frequencies_by(&to_string(&1))
      |> IO.inspect()
      |> Map.values()
      |> IO.inspect()
      |> Enum.filter(fn x -> x > 1 end)
      |> IO.inspect()
  end

  def check(:conseq_lowercase, _password) do
    # TODO
  end

  def check(:conseq_uppercase, _password) do
    # TODO
  end

  def check(:conseq_numbers, _password) do
    # TODO
  end

  def check(:seq_numbers, _password) do
    # TODO
  end

  def check(:seq_alpha, _password) do
    # TODO
  end

  def check(:seq_symbols, _password) do
    # TODO
  end

  def score(password) do
    IO.inspect(check(:length, password))
    IO.inspect(check(:uppercase, password))
    IO.inspect(check(:lowercase, password))
    IO.inspect(check(:numbers, password))
    IO.inspect(check(:symbols, password))
    IO.inspect(check(:middle, password))
    IO.inspect(check(:minimum_req, password))
    IO.inspect(check(:letters_only, password))
    IO.inspect(check(:numbers_only, password))
    IO.inspect(check(:repeat_char, password))
    IO.inspect(check(:conseq_lowercase, password))
    IO.inspect(check(:conseq_uppercase, password))
    IO.inspect(check(:conseq_numbers, password))
    IO.inspect(check(:seq_numbers, password))
    IO.inspect(check(:seq_alpha, password))
    IO.inspect(check(:seq_symbols, password))
  end
end
