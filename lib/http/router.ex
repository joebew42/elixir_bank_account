defmodule Http.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/accounts/:account_name" do
    case Bank.Admin.check_balance(account_name) do
      {:ok, balance} -> send_resp(conn, 200, Poison.encode!(%{"balance" => balance}))
      {:error, :account_not_exists} -> send_resp(conn, 404, "")
    end
  end

  post "/accounts/:account_name" do
    case Bank.Admin.create_account(account_name) do
      {:ok, :account_created} -> send_resp(conn, 201, "/accounts/" <> account_name)
      {:error, :account_already_exists} -> send_resp(conn, 200, "/accounts/" <> account_name)
    end
  end

  put "/accounts/:account_name/deposit" do
    send_resp(conn, 400, "you have to specify an amount")
  end

  put "/accounts/:account_name/deposit/:amount" do
    case deposit(amount, account_name) do
      {:ok} -> send_resp(conn, 204, "")
      {:error, :account_not_exists} -> send_resp(conn, 404, "")
      {:error, :bad_amount_value} -> send_resp(conn, 400, "you have to specify a numeric amount")
    end
  end

  defp deposit(amount, account_name) do
    case Integer.parse(amount) do
      {numeric_value, _} -> Bank.Admin.deposit(numeric_value, account_name)
      _ -> {:error, :bad_amount_value}
    end
  end

  delete "/accounts/:account_name" do
    case Bank.Admin.delete_account(account_name) do
      {:ok, :account_deleted} -> send_resp(conn, 204, "")
      {:error, :account_not_exists} -> send_resp(conn, 404, "")
    end
  end

end
