defmodule Http.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/accounts/:account_name" do
    case Bank.Admin.create_account(account_name) do
      {:ok, :account_created} -> send_resp(conn, 201, "/accounts/" <> account_name)
      {:error, :account_already_exists} -> send_resp(conn, 200, "/accounts/" <> account_name)
    end
  end

  delete "/accounts/:account_name" do
    case Bank.Admin.delete_account(account_name) do
      {:ok, :account_deleted} -> send_resp(conn, 204, "")
      {:error, :account_not_exists} -> send_resp(conn, 404, "")
    end
  end

end
