defmodule Http.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Mock

  @router Http.Router
  @opts @router.init([])

  test "returns 201 when a new account is created" do
    with_mock Bank.Admin, [create_account: fn("joe") -> {:ok, :account_created} end] do
      payload = Poison.encode!(%{name: "joe"})
      conn = do_request(:post, "/accounts", payload)

      assert :sent == conn.state
      assert 201 == conn.status
      assert "/accounts/joe" == conn.resp_body
    end
  end

  defp do_request(verb, endpoint, payload) do
    conn(verb, endpoint, payload)
    |> @router.call(@opts)
  end
end
