# EspecRequestDescriber

Force some rules to write self-documenting request spec.
Inspired by [rspec\-request\_describer](https://github.com/r7kamura/rspec-request_describer)

## Installation

Add `espec_request_describer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:espec_request_describer, "~> 0.1.0", git: "git@github.com:techno-tanoC/espec_request_describer.git"}]
end
```

## Usage

Use `describe_request` function instead `describe` to describe the request.

```elixir
defmodule SomeSpec do
  describe_request "GET /users" do
    it "gets users" do
      IO.inspect subject
      #=> inspects response conn
    end
  end
end
```

If you want to request with params, declear `params`.

```elixir
defmodule SomeSpec do
  describe_request "POST /users" do
    let :params, do: [user: %{name: "hanamaru", email: "zura@gmail.com"}]

    it "posts a user" do
      IO.inspect subject
    end
  end
end
```

`params` is passed to `post conn, "/users", params`.

You can modify conn, too.
