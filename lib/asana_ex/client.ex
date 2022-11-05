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
  def all_workspace_tasks(
        _workspace_gis,
        _assignee_gid,
        _token,
        _fields \\ "name,due_on,due_at,notes",
        _limit \\ 100,
        _offset \\ nil,
        _tasks \\ []
      )

  def all_workspace_tasks([], _assignee_gid, _token, _fields, _limit, _offset, tasks), do: tasks

  def all_workspace_tasks(workspace_gids, assignee_gid, token, fields, limit, _offset, _tasks)
      when is_list(workspace_gids) do
    Task.Supervisor.async_stream(
      AsanaEx.HttpSupervisor,
      workspace_gids,
      __MODULE__,
      :all_workspace_tasks,
      [assignee_gid, token, fields, limit],
      timeout: 30_000
    )
  end

  def all_workspace_tasks(workspace_gid, assignee_gid, token, fields, limit, offset, tasks) do
    params =
      query_params_with_optional_offset(
        [workspace: workspace_gid, assignee: assignee_gid, opt_fields: fields, limit: limit],
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

        all_workspace_tasks(
          workspace_gid,
          assignee_gid,
          fields,
          limit,
          token,
          next_page_offset,
          tasks
        )

      true ->
        tasks ++ response["data"]
    end
  end

  @impl true
  def maybe_get_subtasks(_tasks, _assigneed_gid, _token, _fields \\ nil, _limit \\ 100)
  def maybe_get_subtasks([], _assigneed_gid, _token, _fields, _limit), do: []
  def maybe_get_subtasks(tasks, assignee_gid, token, fields, limit) when is_list(tasks) do
    Task.Supervisor.async_stream(
      AsanaEx.HttpSupervisor,
      tasks,
      __MODULE__,
      :get_subtask,
      [assignee_gid, token, fields, limit],
      timeout: 30_000
    )
  end

  @impl true
  def get_subtask(%{"gid" => task_gid}, assignee_gid, token, fields, limit) do
    path =
      "tasks/" <>
        task_gid <>
        "/subtasks?" <>
        query_params_with_optional_offset(assignee: assignee_gid, opt_fields: fields, limit: limit)

    {:ok, response} = http_impl().build(:get, token, path)

    if is_nil(response["data"]) do
      []
    else
      response["data"]
    end
  end

  defp query_params_with_optional_offset(param_list, offset \\ nil) do
    if is_nil(offset) do
      URI.encode_query(param_list)
    else
      URI.encode_query(param_list ++ [offset: offset])
    end
  end

  defp http_impl, do: Application.get_env(:asana_ex, :client_http, AsanaEx.Client.Http)
end
