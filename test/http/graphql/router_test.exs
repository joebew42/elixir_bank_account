defmodule Http.GraphQL.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @router Http.GraphQL.Router
  @opts @router.init([])

  test "returns the name of the account when new account is created" do
    query = """
      mutation CreateAccount {
        createAccount(name: "joe") {
          name
        }
      }
      """

    result = do_graphql_mutation("/", query, "CreateAccount", "createAccount")

    assert result == %{"name" => "joe"}
  end

  defp do_graphql_mutation(endpoint, query, operation_name, query_name) do
    conn(:post, endpoint, graphql_mutation_payload(query, operation_name))
    |> do_graphql_request(query_name)
  end

  defp do_graphql_request(conn, query_name) do
    conn
    |> @router.call(@opts)
    |> graphql_body_for(query_name)
  end

  defp graphql_mutation_payload(query, operation_name) do
    %{
      "operationName" => "#{operation_name}",
      "query" => "#{query}",
      "variables" => "{}"
    }
  end

  defp graphql_body_for(%Plug.Conn{"resp_body": response_body}, query_name) do
    case Poison.decode!(response_body) do
      %{"data" => %{^query_name => nil}, "errors" => errors} ->
        Enum.map(errors, fn(%{"message" => message}) -> message end)
      %{"data" => %{^query_name => body}} ->
        body
    end
  end
end
