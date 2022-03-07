defmodule AsanaEx do
  @moduledoc """
  Documentation for `AsanaEx`.
  """

  alias Finch.Response

  @base_url "https://app.asana.com/api/1.0"
  @per_page_limit 20

  @doc """
  Retrieve details about self
  """
  def me do
    get("users/me")
  end

  def get(path) do
  end

  def parse_response(response) do
  end

  def query_params(params) do
  end

  @doc """
  Parse workspace gid's from "me"
  """
  def my_workspace_gids() do
    me()
    |> parse_response()
    |> get_in(["data", "workspaces"])
  end

  @doc """
  Retrieve all tasks by workspace gid
  """
  def my_workspace_tasks(_my_gid, _workspace_gis, _offset \\ nil, _tasks \\ [])
  def my_workspace_tasks(_my_gid, [], _offset, tasks), do: tasks
  def my_workspace_tasks(my_gid, [gid | tail], offset, tasks) do
    query_param_list =
      if is_nil(offset) do
        [workspace: gid["gid"], assignee: my_gid]
      else
        [workspace: gid["gid"], assignee: my_gid, offset: offset]
      end

    params = query_params(query_param_list)

    response =
      ("tasks?" <> params)
      |> get()
      |> parse_response()

    tasks = tasks ++ response["data"]

    next_page_offset = get_in(response, ["next_page", "offset"])

    cond do
      is_nil(next_page_offset) -> 
        my_workspace_tasks(my_gid, tail, nil, tasks)

      true ->
        my_workspace_tasks(my_gid, [gid | tail], next_page_offset, tasks)
    end
  end

  defp impl, do: Application.get_env(:asana_ex, :client_host, AsanaEx.Client.Host)
end
