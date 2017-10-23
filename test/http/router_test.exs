defmodule Http.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  @router Http.Router
  @opts @router.init([])

  test "returns 201 when a new account is created" do
    with_mock Bank.Admin, [create_account: fn("joe") -> {:ok, :account_created} end] do
      conn = do_post("/accounts/joe")

      assert :sent == conn.state
      assert 201 == conn.status
      assert "/accounts/joe" == conn.resp_body
    end
  end

  test "returns 200 when try to create an account that is already exists" do
    with_mock Bank.Admin, [create_account: fn("joe") -> {:error, :account_already_exists} end] do
      conn = do_post("/accounts/joe")

      assert :sent == conn.state
      assert 200 == conn.status
      assert "/accounts/joe" == conn.resp_body
    end
  end

  test "returns 204 when an account is deleted" do
    with_mock Bank.Admin, [delete_account: fn("joe") -> {:ok, :account_deleted} end] do
      conn = do_delete("/accounts/joe")

      assert :sent == conn.state
      assert 204 == conn.status
      assert "" == conn.resp_body
    end
  end

  test "returns 404 when try to delete an unexisting account" do
    with_mock Bank.Admin, [delete_account: fn("joe") -> {:error, :account_not_exists} end] do
      conn = do_delete("/accounts/joe")

      assert :sent == conn.state
      assert 404 == conn.status
      assert "" == conn.resp_body
    end
  end

  test "returns 200 and the current balance" do
    with_mock Bank.Admin, [check_balance: fn("joe") -> {:ok, 900} end] do
      conn = do_get("/accounts/joe")

      assert :sent == conn.state
      assert 200 == conn.status
      assert "{\"balance\":900}" == conn.resp_body
    end
  end

  test "returns 404 when try to get the current balance of an unexisting account" do
    with_mock Bank.Admin, [check_balance: fn("joe") -> {:error, :account_not_exists} end] do
      conn = do_get("/accounts/joe")

      assert :sent == conn.state
      assert 404 == conn.status
      assert "" == conn.resp_body
    end
  end

  defp do_get(endpoint) do
    do_request(:get, endpoint)
  end

  defp do_post(endpoint, payload \\ "") do
    do_request(:post, endpoint, payload)
  end

  defp do_delete(endpoint) do
    do_request(:delete, endpoint)
  end

  defp do_request(verb, endpoint) do
    conn(verb, endpoint)
    |> @router.call(@opts)
  end

  defp do_request(verb, endpoint, payload) do
    conn(verb, endpoint, payload)
    |> @router.call(@opts)
  end
end
