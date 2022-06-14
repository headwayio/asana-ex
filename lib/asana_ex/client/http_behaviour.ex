defmodule AsanaEx.Client.HttpBehaviour do
  @moduledoc """
  AsanaEx.Client.HttpBehaviour
  """

  @type method :: AsanaEx.Types.method()
  @type token :: binary()
  @type path :: AsanaEx.Types.path()
  @type body :: AsanaEx.Types.body()
  @type headers :: AsanaEx.Types.headers()
  @type request :: AsanaEx.Types.request()
  @type response :: AsanaEx.Types.response()
  @type exception :: AsanaEx.Types.exception()
  @type request_opts :: AsanaEx.Types.request_opts()

  @callback build(method(), token(), path()) :: response()
  @callback build(method(), token(), path(), headers()) :: response()
  @callback build(method(), token(), path(), headers(), body()) :: response()
  @callback build(method(), token(), path(), headers(), body(), request_opts()) :: response()
  @callback execute(request()) :: {:ok, Finch.Response.t()} | {:error, Exception.t()}
end
