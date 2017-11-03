defmodule Plug.CheckAuthentication do
  import Plug.Conn

  @authorization_service Application.get_env(:bank, :authentication_service)

  def init([]), do: false

  def call(conn, _options) do
    if authenticated?(conn) do
      if @authorization_service.authorized?("badjoe") do
        conn
      else
        conn
        |> send_resp(403, "you are not authorized to access this resource")
        |> halt
      end
    else
      conn
      |> send_resp(401, "")
      |> halt
    end
  end

  defp authenticated?(%Plug.Conn{req_headers: headers}) do
    Enum.find(headers, fn({key, _}) -> key == "auth" end) !== nil
  end
end
