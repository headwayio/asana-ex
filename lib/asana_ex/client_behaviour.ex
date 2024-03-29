defmodule AsanaEx.ClientBehaviour do
  @moduledoc """
  AsanaEx.ClientBehaviour module
  """

  @type gid :: AsanaEx.Types.gid()
  @type token :: binary()
  @type offset :: AsanaEx.Types.offset()
  @type response :: AsanaEx.Types.response()
  @type task :: AsanaEx.Types.task()
  @type fields :: AsanaEx.Types.fields()
  @type limit :: AsanaEx.Types.limit()

  @callback me(token()) :: {:ok, response()}
  @callback all_workspace_tasks(
              list(gid()),
              gid(),
              token(),
              fields(),
              limit(),
              offset() | nil,
              list(task())
            ) ::
              list(task())
  @callback get_subtask(task(), gid(), token(), fields(), limit()) :: list(task())
  @callback maybe_get_subtasks(list(task()), gid(), token(), fields(), limit()) :: list(task())
end
