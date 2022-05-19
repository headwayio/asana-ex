defmodule AsanaEx.Client do
  @moduledoc """
  Single entry into Asana API interaction
  """
  @moduledoc since: "0.0.1"

  @behaviour AsanaEx.ClientBehaviour

  @doc """
  GET details about `me` including all participating workspaces

  Returns `{:ok, %Finch.Response{}}`
  """
  @impl true
  def me(token) do
    http_impl().build(:get, token, "users/me")
  end

  @doc """
  Retrieve all tasks by workspace gid
  """
  @impl true
  def all_workspace_tasks(_workspace_gis, _my_gid, _token, _offset \\ nil, _tasks \\ [])
  def all_workspace_tasks([], _my_gid, _token, _offset, tasks), do: tasks

  def all_workspace_tasks(workspace_gids, my_gid, token, _offset, _tasks)
      when is_list(workspace_gids) do
    Task.Supervisor.async_stream(
      AsanaEx.HttpSupervisor,
      workspace_gids,
      __MODULE__,
      :all_workspace_tasks,
      [my_gid, token],
      timeout: 30_000
    )
  end

  def all_workspace_tasks(workspace_gid, assignee_gid, token, offset, tasks) do
    params =
      build_path_with_offset(
        [workspace: workspace_gid, assignee: assignee_gid, opt_fields: "num_subtasks"],
        offset
      )

    path = "tasks?" <> params

    {:ok, response} = http_impl().build(:get, token, path)

    next_page_offset = get_in(response, ["next_page", "offset"])

    cond do
      is_nil(response["data"]) ->
        tasks

      not is_nil(next_page_offset) ->
        tasks = tasks ++ response["data"]
        all_workspace_tasks(workspace_gid, assignee_gid, token, next_page_offset, tasks)

      true ->
        tasks ++ response["data"]
    end
  end

  @impl true
  def maybe_get_subtasks([], _token), do: []

  def maybe_get_subtasks(tasks, token) when is_list(tasks) do
    Task.Supervisor.async_stream(
      AsanaEx.HttpSupervisor,
      tasks,
      __MODULE__,
      :get_subtask,
      [token],
      timeout: 30_000
    )
  end

  def get_subtask(%{"gid" => task_gid}, token) do
    _params = build_path_with_offset(opt_fields: "num_subtasks")

    path = "tasks/" <> task_gid <> "/subtasks"

    {:ok, response} = http_impl().build(:get, token, path)

    if is_nil(response["data"]) do
      []
    else
      response["data"]
    end
  end

  defp build_path_with_offset(param_list, offset \\ nil) do
    if is_nil(offset) do
      URI.encode_query(param_list)
    else
      URI.encode_query(param_list ++ [offset: offset])
    end
  end

  defp http_impl, do: Application.get_env(:asana_ex, :client_http, AsanaEx.Client.Http)
end
