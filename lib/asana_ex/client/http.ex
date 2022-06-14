defmodule AsanaEx.Client.Http do
  @moduledoc """
  HTTP responsibilities
  """

  @behaviour AsanaEx.Client.HttpBehaviour

  alias AsanaEx.Client.Response

  @finch_instance AsanaFinch

  @impl true
  def build(method, token, path, headers \\ [], body \\ nil, opts \\ []) do
    route = endpoint(path)

    Finch.build(method, route, base_headers(token) ++ headers, body, opts)
    |> execute()
    |> Response.decode()
  end

  @doc """
  Execute HTTP request

  Returns `{:ok, %Finch.Response{}}`
  """
  @impl true
  def execute(request), do: Finch.request(request, @finch_instance)

  defp endpoint(path), do: AsanaEx.Client.Host.connect_url() <> path

  defp base_headers(token),
    do: [{"content-type", "application/json"}, {"Authorization", "Bearer " <> token}]
end
