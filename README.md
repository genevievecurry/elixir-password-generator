# PasswordGenerator

## How do

```
$ iex -S mix

iex()> PasswordGenerator.pin
"01372563"

iex()> PasswordGenerator.random
"1!067qU_"

iex()> PasswordGenerator.memorable
"ICOSTEUS9balsamodendron7DIVULSION2"

iex()> PasswordGenerator.Prompt.start
What type of password do you need?

[1] - Random
[2] - Memorable
[3] - Pin

Type 1, 2 or 3 and press return

```
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `password_generator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:password_generator, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/password_generator](https://hexdocs.pm/password_generator).

