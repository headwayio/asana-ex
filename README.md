# AsanaEx

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `asana_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:asana_ex, "~> 0.1.0"}
  ]
end
```

<!-- livebook:{"force_markdown":true} -->
### Fetch details about self, including workspace gids
```elixir
{:ok, me} = AsanaEx.Client.me(token)
my_gid = me["data"]["gid"]
workspace_gids = Enum.map(me["data"]["workspaces"], fn %{"gid" => gid} -> gid end)
```
<!-- livebook:{"force_markdown":true} -->
### Fetch all tasks for a collection of workspace gids or a single workspace gid:
```elixir
tasks =
  AsanaEx.Client.all_workspace_tasks(workspace_gids, my_gid, token)
  |> Enum.to_list()
  |> Enum.flat_map(fn {:ok, tasks} -> tasks end)
```

<!-- livebook:{"force_markdown":true} -->
### Fetch subtasks for tasks:
```elixir
subtasks =
  AsanaEx.Client.maybe_get_subtasks(tasks, my_gid, token)
  |> Enum.to_list()
  |> Enum.flat_map(fn {:ok, tasks} -> tasks end)
  |> Enum.map(& &1["name"])
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/asana_ex](https://hexdocs.pm/asana_ex).
