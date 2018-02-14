defmodule Http.GraphQL.Resolvers do

  @accounts_administrator Application.get_env(:bank, :accounts_administrator)

  def create_account(_parent, %{name: name}, _resolution) do
    case @accounts_administrator.create_account(name) do
      _ -> {:ok, %{"name": name}}
    end
  end
end
