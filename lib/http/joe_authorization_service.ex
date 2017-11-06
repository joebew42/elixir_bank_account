defmodule Http.JoeAuthorizationService do
  @behaviour Http.AuthorizationService

  def authorized?("joe"), do: true
  def authorized?(_), do: false
end
