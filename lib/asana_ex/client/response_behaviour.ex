defmodule AsanaEx.Client.ResponseBehaviour do
  @type response :: AsanaEx.Types.response
  @type decode_error :: AsanaEx.Types.decode_error

  @callback decode({:ok, response()}) :: {:ok, term()} | {:error, decode_error()}
end

