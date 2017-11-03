defmodule Http.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mox

  @router Http.Router
  @opts @router.init([])

  setup_all do
    start_supervised Mox.Server
    %{}
  end

  describe "when user is not authenticated" do
    test "should receive a 401 when tries to create a new account" do
      conn = do_post("/accounts/joe")

      assert :sent == conn.state
      assert 401 == conn.status
      assert "" == conn.resp_body
    end

    test "should receive a 401 when tries to delete an account" do
      conn = do_delete("/accounts/joe")

      assert :sent == conn.state
      assert 401 == conn.status
      assert "" == conn.resp_body
    end

    test "should receive a 401 when tries to check the current balance" do
      conn = do_get("/accounts/joe")

      assert :sent == conn.state
      assert 401 == conn.status
      assert "" == conn.resp_body
    end
  end

  describe "when user is authenticated" do
    test "returns 201 when a new account is created" do
      expect(Bank.AdminMock, :create_account, fn("joe") -> {:ok, :account_created} end)

      conn = do_authenticated_post("/accounts/joe")

      assert :sent == conn.state
      assert 201 == conn.status
      assert "/accounts/joe" == conn.resp_body

      verify! Bank.AdminMock
    end

    test "returns 200 when try to create an account that is already exists" do
      expect(Bank.AdminMock, :create_account, fn("joe") -> {:error, :account_already_exists} end)

      conn = do_authenticated_post("/accounts/joe")

      assert :sent == conn.state
      assert 200 == conn.status
      assert "/accounts/joe" == conn.resp_body

      verify! Bank.AdminMock
    end

    test "returns 204 when an account is deleted" do
      expect(Bank.AdminMock, :delete_account, fn("joe") -> {:ok, :account_deleted} end)

      conn = do_authenticated_delete("/accounts/joe")

      assert :sent == conn.state
      assert 204 == conn.status
      assert "" == conn.resp_body

      verify! Bank.AdminMock
    end

    test "returns 404 when try to delete an unexisting account" do
      expect(Bank.AdminMock, :delete_account, fn("joe") -> {:error, :account_not_exists} end)

      conn = do_authenticated_delete("/accounts/joe")

      assert :sent == conn.state
      assert 404 == conn.status
      assert "" == conn.resp_body

      verify! Bank.AdminMock
    end

    test "returns 200 and the current balance" do
      expect(Bank.AdminMock, :check_balance, fn("joe") -> {:ok, 900} end)

      conn = do_authenticated_get("/accounts/joe")

      assert :sent == conn.state
      assert 200 == conn.status
      assert "{\"balance\":900}" == conn.resp_body

      verify! Bank.AdminMock
    end

    test "returns 404 when try to get the current balance of an unexisting account" do
      expect(Bank.AdminMock, :check_balance, fn("joe") -> {:error, :account_not_exists} end)

      conn = do_authenticated_get("/accounts/joe")

      assert :sent == conn.state
      assert 404 == conn.status
      assert "" == conn.resp_body

      verify! Bank.AdminMock
    end

    test "returns 204 when deposit amount" do
      expect(Bank.AdminMock, :deposit, fn(100, "joe") -> {:ok} end)

      conn = do_put("/accounts/joe/deposit/100")

      assert :sent == conn.state
      assert 204 == conn.status
      assert "" == conn.resp_body

      verify! Bank.AdminMock
    end

    test "returns 400 when try to deposit with no amount" do
      conn = do_put("/accounts/joe/deposit/")

      assert :sent == conn.state
      assert 400 == conn.status
      assert "you have to specify an amount" == conn.resp_body
    end

    test "returns 400 when try to deposit a non numeric value for amount" do
      conn = do_put("/accounts/joe/deposit/an-amount")

      assert :sent == conn.state
      assert 400 == conn.status
      assert "you have to specify a numeric amount" == conn.resp_body
    end

    test "returns 404 when try to deposit to a non existing account" do
      expect(Bank.AdminMock, :deposit, fn(100, "joe") -> {:error, :account_not_exists} end)

      conn = do_put("/accounts/joe/deposit/100")

      assert :sent == conn.state
      assert 404 == conn.status
      assert "" == conn.resp_body

      verify! Bank.AdminMock
    end

    test "returns 204 when withdraw amount" do
      expect(Bank.AdminMock, :withdraw, fn(100, "joe") -> {:ok} end)

      conn = do_put("/accounts/joe/withdraw/100")

      assert :sent == conn.state
      assert 204 == conn.status
      assert "" == conn.resp_body

      verify! Bank.AdminMock
    end

    test "returns 400 when try to withdraw with no amount" do
      conn = do_put("/accounts/joe/withdraw/")

      assert :sent == conn.state
      assert 400 == conn.status
      assert "you have to specify an amount" == conn.resp_body
    end

    test "returns 400 when try to withdraw a non numeric value for amount" do
      conn = do_put("/accounts/joe/withdraw/an-amount")

      assert :sent == conn.state
      assert 400 == conn.status
      assert "you have to specify a numeric amount" == conn.resp_body
    end

    test "returns 403 when try to withdraw an amount greater than the current balance" do
      expect(Bank.AdminMock, :withdraw, fn(100, "joe") -> {:error, :withdrawal_not_permitted} end)

      conn = do_put("/accounts/joe/withdraw/100")

      assert :sent == conn.state
      assert 403 == conn.status
      assert "the amount you specified is greater than your current balance" == conn.resp_body

      verify! Bank.AdminMock
    end

    test "returns 404 when try to withdraw from a non existing account" do
      expect(Bank.AdminMock, :withdraw, fn(100, "joe") -> {:error, :account_not_exists} end)

      conn = do_put("/accounts/joe/withdraw/100")

      assert :sent == conn.state
      assert 404 == conn.status
      assert "" == conn.resp_body

      verify! Bank.AdminMock
    end
  end

  defp do_authenticated_get(endpoint) do
    do_get(endpoint, [{"auth", "value"}])
  end

  defp do_get(endpoint, headers \\ []) do
    do_request(:get, endpoint, headers)
  end

  defp do_authenticated_post(endpoint) do
    do_post(endpoint, "", [{"auth", "value"}])
  end

  defp do_post(endpoint, payload \\ "", headers \\ []) do
    do_request(:post, endpoint, payload, headers)
  end

  defp do_put(endpoint, payload \\ "", headers \\ []) do
    do_request(:put, endpoint, payload, headers)
  end

  defp do_authenticated_delete(endpoint) do
    do_delete(endpoint, [{"auth", "value"}])
  end

  defp do_delete(endpoint, headers \\ []) do
    do_request(:delete, endpoint, headers)
  end

  defp do_request(verb, endpoint, headers) do
    do_request(verb, endpoint, "", headers)
  end

  defp do_request(verb, endpoint, payload, headers) do
    conn(verb, endpoint, payload)
    |> put_req_headers(headers)
    |> @router.call(@opts)
  end

  defp put_req_headers(conn, []) do
    conn
  end

  defp put_req_headers(conn, [{key, value}|rest]) do
    put_req_headers(put_req_header(conn, key, value), rest)
  end
end
