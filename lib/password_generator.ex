defmodule PasswordOpts do
  defstruct word_count: 3,
            character_count: 8,
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
  A basic password generation module that can create three types of passwords: Random, Memorable, and PIN.

  - Random passwords are hard to crack and hard to remember.
  - Memorable passwords should also be difficult to crack, but are easier to remember as they use full words from the English dictionary
  - PINs are simply a set of numbers


  ## Examples
      iex> PasswordGenerator.start()


  """

  # require Integer

  require PasswordGenerator.Generator
  alias PasswordGenerator.Generator, as: Generator

  def random(options \\ %PasswordOpts{}), do: Generator.random(options)
  def memorable(options \\ %PasswordOpts{}), do: Generator.memorable(options)
  def pin(options \\ %PasswordOpts{}), do: Generator.pin(options)
end
