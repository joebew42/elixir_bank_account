defmodule Http.AuthorizationService do
  @callback authorized?(String.t) :: true | false
end
