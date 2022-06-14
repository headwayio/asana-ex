defmodule AsanaEx.Client.ConfigTest do
  use ExUnit.Case, async: true

  alias AsanaEx.Config

  test "sets ENV scoped by process" do
    Config.set("hello local")
    Config.set(:global, "hello world")

    assert "hello local" == Config.get()
    assert "hello world" == Config.get(:global)
  end
end
