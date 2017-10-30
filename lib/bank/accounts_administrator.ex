defmodule Bank.AccountsAdministrator do
  @callback create_account(String.t) :: {:ok, :account_created} | {:error, :account_already_exists}
  @callback delete_account(String.t) :: {:ok, :account_deleted} | {:error, :account_not_exists}
  @callback check_balance(String.t) :: {:ok, integer()} | {:error, :account_not_exists}
  @callback deposit(integer(), String.t) :: {:ok} | {:error, :account_not_exists}
  @callback withdraw(integer(), String.t) :: {:ok} | {:error, :withdrawal_not_permitted} | {:error, :account_not_exists}
end
