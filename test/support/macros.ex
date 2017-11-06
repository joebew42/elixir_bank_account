defmodule Support.Macros do

  defmacro it_should_receive_an_unauthorized_on(verb, endpoint) do
    quote do
      test unquote("should receive a 401 on #{verb} #{endpoint}") do
        conn = do_request(unquote(verb), unquote(endpoint), [])

        assert :sent == conn.state
        assert 401 == conn.status
        assert "" == conn.resp_body
      end
    end
  end

end
