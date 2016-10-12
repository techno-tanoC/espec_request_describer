defmodule EspecRequestDescriber do
  def reserverd_header_names do
    ~w(Content-Type Host HTTPS)
  end

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
            |> Enum.find(&RequestDescriber.context?/1)
            |> Map.fetch!(:description)

          Regex.run(
            ~r/(#{RequestDescriber.supported_methods |> Enum.join("|")}) (\S+)/i,
            description,
            capture: :all_but_first
          )
        end

        let :http_method, do: endpoint_segments |> Enum.at(0) |> String.downcase |> String.to_atom
        let :request_path, do: endpoint_segments |> Enum.at(1)

        let :send_request do
          Phoenix.ConnTest.dispatch(conn, @endpoint, http_method, request_path, params)
        end

        subject do: send_request

        unquote(block)
      end
    end
  end

  def context?(value) do
    case value do
      %ESpec.Context{} -> true
      _                -> false
    end
  end

  defmacro __using__(_opts) do
    quote do
      import RequestDescriber, only: [describe_request: 2]
    end
  end
end
