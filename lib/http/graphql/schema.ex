defmodule Http.GraphQL.Schema do
  use Absinthe.Schema
  import_types Http.GraphQL.Types

  alias Http.GraphQL.Resolvers

  query do
  end

  mutation do
    @desc "Create Account"
    field :create_account, type: :account do
      arg :name, non_null(:string)

      resolve &Resolvers.create_account/3
    end
  end
end
