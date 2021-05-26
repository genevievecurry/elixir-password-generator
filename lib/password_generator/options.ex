defmodule PasswordGenerator.Options do
  @moduledoc """
  This module sets the default options for password generation.

  ```
  word_count: integer,
  character_count: integer,
  uppercase: boolean,
  separator_type: atom, # See @separator_types
  symbols: boolean,
  numbers: boolean
  ```
  """

  defstruct word_count: 3,
            character_count: 8,
            uppercase: true,
            separator_type: :digits,
            symbols: true,
            numbers: true
end
