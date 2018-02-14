defmodule Http.GraphQL.Resolvers do

  @accounts_administrator Application.get_env(:bank, :accounts_administrator)

  def create_account(_parent, %{name: name}, _resolution) do
    case @accounts_administrator.create_account(name) do
      {:error, :account_already_exists} -> {:error, "The account " <> name <> " is already existing"}
      _ -> {:ok, %{"name": name}}
    end
  end

  def delete_account(_parent, %{name: name}, _resolution) do
    case @accounts_administrator.delete_account(name) do
      {:error, :account_not_exists} -> {:error, "The account " <> name <> " is not existing"}
      _ -> {:ok, %{"name": name}}
    end
  end

  def find_account(_parent, %{name: name}, _resolution) do
    case @accounts_administrator.check_balance(name) do
      {:ok, balance} -> {:ok, %{"balance": balance}}
      _ -> {:error, "The account " <> name <> " is not existing"}
    end
  end
end
