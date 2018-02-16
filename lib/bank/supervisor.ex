defmodule Bank.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      Bank.Admin,
      Bank.AccountSupervisor,
      Bank.AccountRegistry,
      Plug.Adapters.Cowboy.child_spec(:http, Http.Router, [], [port: 4000]),
      Plug.Adapters.Cowboy.child_spec(:http, Http.GraphQL.Router, [], [port: 5000])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
