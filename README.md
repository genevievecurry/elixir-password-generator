# Password Generator

This is a simple password generator and password analysis tool. It is not optimized for use in production situations, as it was developed as a project to teach myself Elixir.

You can see it in action in a separate project (using Phoenix for a UI) here: https://phoenix-password-generator.fly.dev/

There are a few different ways to interact with the tool:

- Start a session in iex and generate passwords using default settings, or by using the IO prompts, which allow you to set passwords a little more conversationally.

- Call any of the functions related to password analysis or generation by passing in the correct arguments.

## Generator

The generator is based on the password helper in 1Password (for the most part). It can generate the following types of passwords:

1. **Random** passwords are hard to crack and hard to remember.
2. **Memorable** passwords should also be difficult to crack, but are easier to remember as they use full words from the English dictionary
3. **PINs** are simply a set of numbers

Each generator uses the struct defined in `Password.Options` as its defaults, so it is unnecessary to pass in custom options if they're not necessary.

### PINs

`Password.Generator.random(options)`

#### Options:

```
%Options{
  pin_length: integer
}
```

### Random Passwords

`Password.Generator.random(options)`

#### Options:

```
%Options{
  character_count: integer,
  symbols: boolean,
  numbers: boolean
}
```

### Memorable Passwords

This generator uses a rather large text file of english words to provide the word library. The text file is from [# https://github.com/dwyl/english-words](https://github.com/dwyl/english-words).

`Password.Generator.memorable(options)`

#### Options:

```
%Options{
  word_count: integer,
  separator_type: atom,
  uppercase: boolean,
  symbols: boolean,
  numbers: boolean
}
```

#### Separator Types:

The following separator types are available as atoms:

```
:none,
:hyphens,
:underscores,
:periods,
:spaces,
:digits,
:symbols
```

## Analysis

Each factor tests various traits of a secure password. These factors are fairly arbitrary and based almost entirely on the Password Meter tool found here: [http://www.passwordmeter.com/](http://www.passwordmeter.com/).

Analysis can provide the following:

### Results

`Password.Analyzer.results(string)`

Returns a list with each factor. Each factor provides whether or not it is classified as an addition or deduction, and the associated point value (either positive, `0`, or negative).

### Score

`Password.Analyzer.score(string)`

Returns the summed value of points from all factors. Lowest value is `0`.

### Strength

`Password.Analyzer.strength(integer)`

Convenience function that accepts a score and returns a normalized value between `0` and `100`, to be used as a strength percentage.

## Basic Usage (with iex)

### Generate Password

```
$ iex -S mix

iex()> Password.pin
"0137"

iex()> Password.random
"1!067qU_"

iex()> Password.memorable
"ICOSTEUS9balsamodendron7DIVULSION2"

iex()> Password.Prompt.start
What type of password do you need?

[1] - Random
[2] - Memorable
[3] - Pin

Type 1, 2 or 3 and press return

```

### Analyze Password

```
$ iex -S mix

iex()> Password.analyze("your-secure-password")

%{
  results: [
    length: {:addition, 80},
    uppercase: {:addition, 0},
    lowercase: {:addition, 4},
    numbers: {:addition, 0},
    symbols: {:addition, 12},
    middle: {:addition, 0},
    minimum_requirements: {:addition, 0},
    letters_only: {:deduction, 0},
    repeat_characters: {:deduction, -7},
    consecutive_lowercase: {:deduction, -15},
    consecutive_uppercase: {:deduction, 0},
    consecutive_numbers: {:deduction, 0},
    sequential_numbers: {:deduction, 0},
    sequential_alpha: {:deduction, 0},
    sequential_symbols: {:deduction, 0}
  ],
  score: 74,
  strength: 49
}

```

## To-Dos

There are a few things that deserve a little more attention at this point:

1. The `middle` factor for password analysis is not completed. I'm on the fence about its value. It is meant to test if there are numbers or symbols in the middle of the password string (not just at the start or end).

2. Additional tests. Testing is a bit minimalist at this point; admittedly as someone who has been doing front-end development for the last decade, I'm not in the TDD club and writing tests for a language as I am learning it seems like a little too much extra overhead at this point.

3. Better documentation. I hear that one of the fantastic benefits of using Elixir is the inlined documentation.
