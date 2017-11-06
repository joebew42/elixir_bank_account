defmodule Plug.CheckAuthentication do
  import Plug.Conn

  @authorization_service Application.get_env(:bank, :authentication_service)

  def init([]), do: false

  def call(conn, _options) do
    case check_for_authorization(conn) do
      {:error, :not_authenticated} ->
        conn
        |> send_resp(401, "")
        |> halt
      {:error, :not_authorized} ->
        conn
        |> send_resp(403, "you are not authorized to access this resource")
        |> halt
      {:ok, :authorized} -> conn
    end
  end

  defp check_for_authorization(conn) do
    case credentials_from(conn) do
      nil -> {:error, :not_authenticated}
      credentials ->
        if @authorization_service.authorized?(credentials) do
          {:ok, :authorized}
        else
          {:error, :not_authorized}
        end
    end
  end

  defp credentials_from(%Plug.Conn{req_headers: headers}) do
    case Enum.find(headers, fn({key, _}) -> key == "auth" end) do
      {_, credentials} -> credentials
      _ -> nil
    end
  end
end
