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

  test "returns 201 when a new account is created" do
    Bank.AdminMock
    |> expect(:create_account, fn("joe") -> {:ok, :account_created} end)

    conn = do_post("/accounts/joe")

    assert :sent == conn.state
    assert 201 == conn.status
    assert "/accounts/joe" == conn.resp_body

    verify! Bank.AdminMock
  end

  test "returns 200 when try to create an account that is already exists" do
    Bank.AdminMock
    |> expect(:create_account, fn("joe") -> {:error, :account_already_exists} end)

    conn = do_post("/accounts/joe")

    assert :sent == conn.state
    assert 200 == conn.status
    assert "/accounts/joe" == conn.resp_body

    verify! Bank.AdminMock
  end

  test "returns 204 when an account is deleted" do
    Bank.AdminMock
    |> expect(:delete_account, fn("joe") -> {:ok, :account_deleted} end)

    conn = do_delete("/accounts/joe")

    assert :sent == conn.state
    assert 204 == conn.status
    assert "" == conn.resp_body

    verify! Bank.AdminMock
  end

  test "returns 404 when try to delete an unexisting account" do
    Bank.AdminMock
    |> expect(:delete_account, fn("joe") -> {:error, :account_not_exists} end)

    conn = do_delete("/accounts/joe")

    assert :sent == conn.state
    assert 404 == conn.status
    assert "" == conn.resp_body

    verify! Bank.AdminMock
  end

  test "returns 200 and the current balance" do
    Bank.AdminMock
    |> expect(:check_balance, fn("joe") -> {:ok, 900} end)

    conn = do_get("/accounts/joe")

    assert :sent == conn.state
    assert 200 == conn.status
    assert "{\"balance\":900}" == conn.resp_body

    verify! Bank.AdminMock
  end

  test "returns 404 when try to get the current balance of an unexisting account" do
    Bank.AdminMock
    |> expect(:check_balance, fn("joe") -> {:error, :account_not_exists} end)

    conn = do_get("/accounts/joe")

    assert :sent == conn.state
    assert 404 == conn.status
    assert "" == conn.resp_body

    verify! Bank.AdminMock
  end

  test "returns 204 when deposit amount" do
    Bank.AdminMock
    |> expect(:deposit, fn(100, "joe") -> {:ok} end)

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
    Bank.AdminMock
    |> expect(:deposit, fn(100, "joe") -> {:error, :account_not_exists} end)

    conn = do_put("/accounts/joe/deposit/100")

    assert :sent == conn.state
    assert 404 == conn.status
    assert "" == conn.resp_body

    verify! Bank.AdminMock
  end

  test "returns 204 when withdraw amount" do
    Bank.AdminMock
    |> expect(:withdraw, fn(100, "joe") -> {:ok} end)

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
    Bank.AdminMock
    |> expect(:withdraw, fn(100, "joe") -> {:error, :withdrawal_not_permitted} end)

    conn = do_put("/accounts/joe/withdraw/100")

    assert :sent == conn.state
    assert 403 == conn.status
    assert "the amount you specified is greater than your current balance" == conn.resp_body

    verify! Bank.AdminMock
  end

  test "returns 404 when try to withdraw from a non existing account" do
    Bank.AdminMock
    |> expect(:withdraw, fn(100, "joe") -> {:error, :account_not_exists} end)

    conn = do_put("/accounts/joe/withdraw/100")

    assert :sent == conn.state
    assert 404 == conn.status
    assert "" == conn.resp_body

    verify! Bank.AdminMock
  end

  defp do_get(endpoint) do
    do_request(:get, endpoint)
  end

  defp do_post(endpoint, payload \\ "") do
    do_request(:post, endpoint, payload)
  end

  defp do_put(endpoint, payload \\ "") do
    do_request(:put, endpoint, payload)
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
