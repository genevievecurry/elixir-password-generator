defmodule Analyser.Factor do
  @alpha 'abcdefghijklmnopqrstuvwxyz'
  @symbols '`!@#$%^&*()-='
  @factors [
    :length,
    :uppercase,
    :lowercase,
    :numbers,
    :symbols,
    :middle,
    :minimum_req,
    :letters_only,
    :repeat_char,
    :consecutive_lowercase,
    :consecutive_uppercase,
    :consecutive_numbers,
    :seq_numbers,
    :seq_alpha,
    :seq_symbols
  ]

  def check(type, password)

  def check(:length, password) do
    {:addition, String.length(password) * 4}
  end

  def check(:uppercase, password) do
    length = String.length(password)
    count = Regex.scan(~r/[[:upper:]]/u, password) |> Enum.count()

    cond do
      count > 0 -> {:addition, (length - count) * 2}
      true -> {:addition, 0}
    end
  end

  def check(:lowercase, password) do
    length = String.length(password)
    count = Regex.scan(~r/[[:lower:]]/u, password) |> Enum.count()
    {:addition, (length - count) * 2}
  end

  def check(:numbers, password) do
    count = Regex.scan(~r/[[:digit:]]/u, password) |> Enum.count()
    {:addition, count * 4}
  end

  def check(:symbols, password) do
    count = Regex.scan(~r/[*!#$%+-.?@&^()=~`_]/u, password) |> Enum.count()
    {:addition, count * 6}
  end

  def check(:middle, _password) do
    # TO-DO
    {:addition, 0}
  end

  def check(:minimum_req, password) do
    # At least 1 number, 1 special character, mix of upper and lower characters, between 8-100 characters long
    strong_password_regex = ~r/((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[\W]).{8,100})/u

    cond do
      Regex.match?(strong_password_regex, password) == true -> {:addition, 10}
      true -> {:addition, 0}
    end
  end

  def check(:letters_only, password) do
    length = String.length(password)
    count = Regex.scan(~r/[[:alpha:]]/u, password) |> Enum.count()

    cond do
      length == count -> {:deduction, count * -1}
      true -> {:deduction, 0}
    end
  end

  def check(:numbers_only, password) do
    length = String.length(password)
    count = Regex.scan(~r/[[:digit:]]/u, password) |> Enum.count()

    cond do
      length == count -> {:deduction, count * -1}
      true -> {:deduction, 0}
    end
  end

  def check(:repeat_char, password) do
    length = String.length(password)

    repeated =
      String.split(password, "", trim: true)
      |> Enum.frequencies_by(&to_string(&1))
      |> Map.values()
      |> Enum.filter(fn x -> x > 1 end)
      |> Enum.reduce(0, fn int, acc -> int + acc end)

    {:deduction, round(length / repeated) * -1}
  end

  def check(:consecutive_lowercase, password) do
    # Finds sets of consecutive lowercase letters
    # Enumerates through each set and multiplies it by two
    # Takes the resulting list and adds up each value to arrive at score

    score =
      Regex.scan(~r/[[:lower:]]{2,}(?=[a-z])/u, password)
      |> List.flatten()
      |> Enum.map(fn set -> String.length(set) * 2 end)
      |> Enum.reduce(0, fn int, acc -> int + acc end)

    {:deduction, score * -1}
  end

  def check(:consecutive_uppercase, password) do
    score =
      Regex.scan(~r/[[:upper:]]{2,}(?=[A-Z])/u, password)
      |> List.flatten()
      |> Enum.map(fn set -> String.length(set) * 2 end)
      |> Enum.reduce(0, fn int, acc -> int + acc end)

    {:deduction, score * -1}
  end

  def check(:consecutive_numbers, password) do
    score =
      Regex.scan(~r/[[:digit:]]{2,}(?=[0-9])/u, password)
      |> List.flatten()
      |> Enum.map(fn set -> String.length(set) * 2 end)
      |> Enum.reduce(0, fn int, acc -> int + acc end)

    {:deduction, score * -1}
  end

  def check(:seq_numbers, password) do
    sequential_score =
      Enum.chunk_every(0..10, 3, 1, :discard)
      |> Enum.map(fn set -> Enum.join(set) end)
      |> Enum.map(fn set -> String.contains?(password, set) end)
      |> Enum.count(fn matched -> matched end)

    reverse_sequential_score =
      Enum.chunk_every(10..0, 3, 1, :discard)
      |> Enum.map(fn set -> Enum.join(set) end)
      |> Enum.map(fn set -> String.contains?(password, set) end)
      |> Enum.count(fn matched -> matched end)

    {:deduction, (sequential_score + reverse_sequential_score) * 3 * -1}
  end

  def check(:seq_alpha, password) do
    normalized = String.downcase(password)

    sequential_score =
      Enum.chunk_every(@alpha, 3, 1)
      |> Enum.map(fn set -> String.contains?(normalized, List.to_string(set)) end)
      |> Enum.count(fn matched -> matched end)

    reverse_sequential_score =
      Enum.reverse(@alpha)
      |> Enum.chunk_every(3, 1)
      |> Enum.map(fn set -> String.contains?(normalized, List.to_string(set)) end)
      |> Enum.count(fn matched -> matched end)

    {:deduction, (sequential_score + reverse_sequential_score) * 3 * -1}
  end

  def check(:seq_symbols, password) do
    # TO-DO

    sequential_score =
      Enum.chunk_every(@symbols, 3, 1, :discard)
      |> Enum.map(fn set -> to_string(set) end)
      |> Enum.map(fn set -> String.contains?(password, set) end)
      |> Enum.count(fn matched -> matched end)

    reverse_sequential_score =
      Enum.reverse(@symbols)
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.map(fn set -> to_string(set) end)
      |> Enum.map(fn set -> String.contains?(password, set) end)
      |> Enum.count(fn matched -> matched end)

    {:deduction, (sequential_score + reverse_sequential_score) * 3 * -1}
  end

  def score(password) do
    Enum.map(@factors, fn factor -> check(factor, password) end)
    |> Enum.reduce(0, fn {_key, val}, acc -> val + acc end)
  end

  def results(password) do
    Enum.map(@factors, fn factor -> {factor, check(factor, password)} end)
  end
end
