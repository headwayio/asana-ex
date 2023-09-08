# AsanaEx

**Asana API wrapper: [API Reference](https://developers.asana.com/reference/rest-api-reference)**

This is intended to support [Birdseye](www.usebirdseye.com) and aims to quickly fetch workspaces, projects, tasks, and subtasks. Pagination and subtask retrieval is challenging and this library attempts to wrap that work in a single call:

```elixir
# Fetch user information
response = AsanaEx.Client.me("my-token")

# {:ok, %{"data" => %{"email" => "user@headway.io"}}}

# Fetch all projects by workspace GUIDs
workspace_gids = ["12345", "67890"]

AsanaEx.Client.all_workspace_projects("my-assignee-gid", "my-token")
|> Enum.to_list()
|> Enum.flat_map(fn {_, items} -> items end)

# Fetch all tasks by workspace GUIDs
workspace_gids = ["12345", "67890"]

workspace_gids
|> AsanaEx.Client.all_workspace_tasks("my-assignee-gid", "my-token")
|> Enum.to_list()
|> Enum.flat_map(fn {_, items} -> items end)
```

This library does not account for Asana's rate limits and Asana's API does much more than this is implemented here.

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

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/asana_ex](https://hexdocs.pm/asana_ex).

