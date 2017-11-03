defmodule Plug.CheckAuthentication do
  import Plug.Conn

  def init([]), do: false

  def call(conn, _options) do
    if authenticated?(conn) do
      conn
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
