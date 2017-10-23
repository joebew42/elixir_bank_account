defmodule Http.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/accounts" do
    {:ok, body, _conn} = read_body(conn)
    %{"name" => name} = Poison.decode!(body)

    case Bank.Admin.create_account(name) do
      {:ok, :account_created} -> send_resp(conn, 201, "/accounts/" <> name)
      {:error, :account_already_exists} -> send_resp(conn, 200, "/accounts/" <> name)
    end
  end

end
