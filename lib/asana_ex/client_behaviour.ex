defmodule AsanaEx.ClientBehaviour do
  @type gid :: AsanaEx.Types.gid
  @type token :: binary()
  @type offset :: AsanaEx.Types.offset
  @type response :: AsanaEx.Types.response
  @type task :: AsanaEx.Types.task

  @callback me(token()) :: {:ok, response()}
  @callback all_workspace_tasks(token(), list(gid()) | gid(), gid(), offset() | nil, list(task())) :: list(task())
  @callback maybe_get_subtasks(token(), list(task())) :: list(task())
end
