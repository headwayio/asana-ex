defmodule AsanaEx.Types do
  @moduledoc """
  Share type definitions
  """

  @type gid :: String.t()
  @type offset :: String.t()
  @type task :: map()
  @type body :: Finch.Request.body()
  @type request :: Finch.Request.t()
  @type headers :: Finch.Request.headers()
  @type request_opts :: Keyword.t()
  @type decode_error :: Jason.decode_error()
  @type response :: {:ok, term()} | {:error, Jason.DecodeError.t()}
end
