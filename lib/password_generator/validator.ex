defmodule PasswordGenerator.Validator do
  @spec parse_integer(binary) :: :error | {integer, binary}
  def parse_integer(value) do
    case value |> String.trim() |> Integer.parse() do
      {value, _base} ->
        value

      _ ->
        :error
    end
  end

  @spec check_length_input(binary | integer, any, any) :: :error | integer
  def check_length_input(value, min, max) when is_bitstring(value) do
    parsed_value = parse_integer(value)

    cond do
      parsed_value >= min and parsed_value <= max ->
        parsed_value

      true ->
        :error
    end
  end

  def check_length_input(value, min, max) when is_integer(value) do
    cond do
      value >= min and value <= max ->
        value

      true ->
        :error
    end
  end

  @spec separator_input(binary) :: atom
  def separator_input(value) when is_bitstring(value) do
    value |> String.trim() |> String.to_atom()
  end

  @spec bool_input(boolean | binary) :: boolean
  def bool_input(value) when is_bitstring(value) do
    Enum.member?(["y\n", "yes\n", "\n"], String.downcase(value))
  end

  def bool_input(value) when is_boolean(value), do: value
end
