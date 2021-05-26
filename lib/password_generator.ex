defmodule PasswordGenerator do
  @moduledoc """
  A basic password generation module that can create three types of passwords: Random, Memorable, and PIN.

  - Random passwords are hard to crack and hard to remember.
  - Memorable passwords should also be difficult to crack, but are easier to remember as they use full words from the English dictionary
  - PINs are simply a set of numbers


  ## Examples
      iex> PasswordGenerator.start()


  """
  alias PasswordGenerator.Generator
  alias PasswordGenerator.Options

  def random(options \\ %Options{}), do: Generator.random(options)
  def memorable(options \\ %Options{}), do: Generator.memorable(options)
  def pin(options \\ %Options{}), do: Generator.pin(options)
end
