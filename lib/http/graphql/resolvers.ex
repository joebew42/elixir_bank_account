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

  def deposit_amount(_parent, %{name: name, amount: amount}, _resolution) do
    case @accounts_administrator.deposit(amount, name) do
      {:ok} ->
        {:ok, balance} = @accounts_administrator.check_balance(name)
        {:ok, %{"balance": balance}}
      _ ->
        {:error, "The account " <> name <> " is not existing"}
    end
  end

  def withdraw_amount(_parent, %{name: name, amount: amount}, _resolution) do
    case @accounts_administrator.withdraw(amount, name) do
      {:ok} ->
        {:ok, balance} = @accounts_administrator.check_balance(name)
        {:ok, %{"balance": balance}}
      {:error, :withdrawal_not_permitted} ->
        {:error, "The amount you specified is greater than your current balance"}
      _ ->
        {:error, "The account " <> name <> " is not existing"}
    end
  end
end
