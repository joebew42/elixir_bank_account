defmodule Http.GraphQL.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mox

  @router Http.GraphQL.Router
  @opts @router.init([])

  setup_all do
    start_supervised Mox.Server
    %{}
  end

  test "returns the name of the account when new account is created" do
    expect(Bank.AdminMock, :create_account, fn("joe") -> {:ok, :account_created} end)

    query = """
      mutation CreateAccount {
        createAccount(name: "joe") {
          name
        }
      }
      """

    result = do_graphql_mutation("/", query, "CreateAccount", "createAccount")

    assert result == %{"name" => "joe"}
    verify! Bank.AdminMock
  end

  test "returns an error message when try to create an account that is already exists" do
    expect(Bank.AdminMock, :create_account, fn("joe") -> {:error, :account_already_exists} end)

    query = """
      mutation CreateAccount {
        createAccount(name: "joe") {
          name
        }
      }
      """

    errors = do_graphql_mutation("/", query, "CreateAccount", "createAccount")

    assert contains?(errors, "The account joe is already existing")
    verify! Bank.AdminMock
  end

  test "returns the name when an account is deleted" do
    expect(Bank.AdminMock, :delete_account, fn("joe") -> {:ok, :account_deleted} end)

    query = """
      mutation DeleteAccount {
        deleteAccount(name: "joe") {
          name
        }
      }
      """

    result = do_graphql_mutation("/", query, "DeleteAccount", "deleteAccount")

    assert result == %{"name" => "joe"}
    verify! Bank.AdminMock
  end

  test "returns an error message when try to delete an unexisting account" do
    expect(Bank.AdminMock, :delete_account, fn("joe") -> {:error, :account_not_exists} end)

    query = """
      mutation DeleteAccount {
        deleteAccount(name: "joe") {
          name
        }
      }
      """

    errors = do_graphql_mutation("/", query, "DeleteAccount", "deleteAccount")

    assert contains?(errors, "The account joe is not existing")
    verify! Bank.AdminMock
  end

  defp contains?(enumerable, element), do: Enum.member?(enumerable, element)

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
