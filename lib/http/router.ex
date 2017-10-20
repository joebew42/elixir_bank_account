defmodule Http.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/accounts" do
    {:ok, body, _conn} = read_body(conn)
    %{"name" => name} = Poison.decode!(body)

    {:ok, :account_created} = Bank.Admin.create_account(name)

    send_resp(conn, 201, "/accounts/" <> name)
  end

end
