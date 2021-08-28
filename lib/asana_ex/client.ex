defmodule AsanaEx.Client do
  @moduledoc """
  Single entry into Asana API interaction
  """
  @moduledoc since: "0.0.1"

  @finch_instance AsanaFinch

  @doc """
  GET details about `me` including all participating workspaces

  Returns `{:ok, %Finch.Response{}}`

  Examples:
    
    iex> AsanaEx.Client.me()
    %Finch.Request{method: "GET", scheme: :https, body: nil, host: "app.asana.com", port: 443, path: "/api/1.0/users/me", headers: [], query: nil}

  """
  @spec me(Finch.Request.url()) :: {:ok, %Finch.Response{}}
  def me(url \\ "https://app.asana.com") do
    Finch.build(:get, url <> "/api/1.0/users/me")
  end

  @doc """
  Execute HTTP request

  Returns `{:ok, %Finch.Response{}}`
  """
  @spec execute(Finch.Request.t()) :: {:ok, Finch.Response.t()}
  def execute(%Finch.Request{} = request) do
    request
    |> Finch.request(@finch_instance)
  end
end
