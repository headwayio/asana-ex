defmodule AsanaEx.ClientTest do
  use ExUnit.Case, async: true

  import Mox
  import AsanaEx.RequestHelpers

  alias AsanaEx.Client.MockHttp

  @moduletag timeout: :infinity

  doctest AsanaEx.Client

  setup :set_mox_from_context
  setup :verify_on_exit!

  test "builds and requests Asana request for @me endpoint" do
    expect(MockHttp, :build, 1, fn _method, _path -> {:ok, fixture("me.json")} end)

    response = AsanaEx.Client.me()

    assert {:ok, %{"data" => %{"email" => "tester@headway.io"}}} = response
  end

  test "builds and requests Asana request for workspace tasks" do
    parent = self()
    ref = make_ref()

    expect(MockHttp, :build, 1, fn :get, _path ->
      send(parent, {ref, :three})
      {:ok, fixture("workspace2.json")}
    end)

    expect(MockHttp, :build, 1, fn :get, _path ->
      send(parent, {ref, :one})
      {:ok, fixture("workspace1.json")}
    end)

    expect(MockHttp, :build, 1, fn :get, _path ->
      send(parent, {ref, :two})
      {:ok, fixture("workspace1b.json")}
    end)

    workspace_gids = ["12345", "67890"]

    tasks =
      AsanaEx.Client.all_workspace_tasks(workspace_gids, "12345")
      |> Enum.to_list()
      |> Enum.flat_map(fn {_, items} -> items end)

    assert_receive {^ref, :one}
    assert_receive {^ref, :two}
    assert_receive {^ref, :three}

    assert 15 = Enum.count(tasks)
  end

  test "recursively retrieves subtasks for a collection of tasks" do
    parent = self()
    ref = make_ref()

    expect(MockHttp, :build, 1, fn :get, _path ->
      send(parent, {ref, :one})
      {:ok, fixture("task1.json")}
    end)

    expect(MockHttp, :build, 1, fn :get, _path ->
      send(parent, {ref, :two})
      {:ok, fixture("task1_subtask1.json")}
    end)

    expect(MockHttp, :build, 1, fn :get, _path ->
      send(parent, {ref, :three})
      {:ok, fixture("task1_subtask2.json")}
    end)

    tasks =
      AsanaEx.Client.maybe_get_subtasks([[gid: "12345", num_subtasks: 0], [gid: "67890", num_subtasks: 2]])
      |> Enum.to_list()
      |> Enum.flat_map(fn {_, items} -> items end)

    assert_receive {^ref, :one}
    assert_receive {^ref, :two}
    assert_receive {^ref, :three}
  end
end
