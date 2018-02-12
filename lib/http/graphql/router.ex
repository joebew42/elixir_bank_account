defmodule Http.GraphQL.Router do
  use Plug.Router

  plug :match
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Poison
  plug :dispatch

  forward "/",
    to: Absinthe.Plug,
    init_opts: [schema: Http.GraphQL.Schema]
end
