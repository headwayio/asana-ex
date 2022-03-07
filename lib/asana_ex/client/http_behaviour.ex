defmodule AsanaEx.Client.HttpBehaviour do
  @type method :: AsanaEx.Types.method
  @type token :: binary()
  @type path :: AsanaEx.Types.path
  @type body :: AsanaEx.Types.body
  @type headers :: AsanaEx.Types.headers
  @type request :: AsanaEx.Types.request
  @type response :: AsanaEx.Types.response
  @type request_opts :: AsanaEx.Types.request_opts

  @callback build(method(), token(), path()) :: request()
  @callback build(method(), token(), path(), headers()) :: request()
  @callback build(method(), token(), path(), headers(), body()) :: request()
  @callback build(method(), token(), path(), headers(), body(), request_opts()) :: request()
  @callback execute(request()) :: {:ok, response()}
end

