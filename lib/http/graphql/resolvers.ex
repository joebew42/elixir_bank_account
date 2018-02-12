defmodule Http.GraphQL.Resolvers do
  def create_account(_parent, _args, _resolution) do
    {:ok, %{"name": "joe"}}
  end
end
