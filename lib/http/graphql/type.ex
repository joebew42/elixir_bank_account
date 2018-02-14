defmodule Http.GraphQL.Types do
  use Absinthe.Schema.Notation

  object :account do
    field :name, :string
    field :balance, :integer
  end
end
