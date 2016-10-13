defmodule EspecRequestDescriber do
  def supported_methods do
    ~w(GET POST PUT PATCH DELETE)
  end

  defmacro describe_request(desc, opts \\ [], do: block) do
    quote do
      describe(unquote(desc), unquote(opts)) do
        let :conn, do: build_conn
        let :params, do: nil

        let :endpoint_segments do
          description =
            @context
            |> Enum.find(&(&1.__struct__ == ESpec.Context))
            |> Map.fetch!(:description)

          Regex.run(
            ~r/(#{EspecRequestDescriber.supported_methods |> Enum.join("|")}) (\S+)/i,
            description,
            capture: :all_but_first
          )
        end

        let :http_method, do: endpoint_segments |> Enum.at(0) |> String.downcase |> String.to_atom
        let :request_path do
          path = endpoint_segments |> Enum.at(1)
          fun = fn _, x -> "#{apply(__MODULE__, String.to_atom(x), [])}" end
          Regex.replace(~r/:(\w+[!?]?)/, path, fun)
        end

        let :send_request do
          Phoenix.ConnTest.dispatch(conn, @endpoint, http_method, request_path, params)
        end

        subject do: send_request

        unquote(block)
      end
    end
  end

  defmacro rdescribe(desc, opts \\ [], do: block) do
    quote do: describe_request(unquote(desc), unquote(opts), do: unquote(block))
  end

  defmacro __using__(_opts) do
    quote do
      import EspecRequestDescriber, except: [supported_methods: 0]
    end
  end
end
