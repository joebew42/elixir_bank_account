defmodule Http.GraphQL.Schema do
  use Absinthe.Schema
  import_types Http.GraphQL.Types

  alias Http.GraphQL.Resolvers

  query do
    @desc "Get an account"
    field :account, :account do
      arg :name, non_null(:string)

      resolve &Resolvers.find_account/3
    end
  end

  mutation do
    @desc "Create Account"
    field :create_account, type: :account do
      arg :name, non_null(:string)

      resolve &Resolvers.create_account/3
    end

    @desc "Delete Account"
    field :delete_account, type: :account do
      arg :name, non_null(:string)

      resolve &Resolvers.delete_account/3
    end

    @desc "Deposit an amount"
    field :deposit, type: :account do
      arg :name, non_null(:string)
      arg :amount, non_null(:integer)

      resolve &Resolvers.deposit_amount/3
    end

    @desc "Withdraw an amount"
    field :withdraw, type: :account do
      arg :name, non_null(:string)
      arg :amount, non_null(:integer)

      resolve &Resolvers.withdraw_amount/3
    end
  end
end
