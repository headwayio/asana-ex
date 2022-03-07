defmodule AsanaEx.Client.ResponseTest do
  use ExUnit.Case, async: true

  doctest AsanaEx.Client.Response

  test "decodes Finch.Response body into JSON" do
    json = AsanaEx.Client.Response.decode(%Finch.Response{body: "{\"data\":{\"gid\":\"abc123\"}}"})
    assert {:ok, %{"data" => %{"gid" => "abc123"}}} = json
  end

  test "decodes Finch.Response body within an ok tuple into JSON" do
    json =
      {:ok, %Finch.Response{body: "{\"data\":{\"gid\":\"abc123\"}}"}}
      |> AsanaEx.Client.Response.decode()

    assert {:ok, %{"data" => %{"gid" => "abc123"}}} = json
  end
end
