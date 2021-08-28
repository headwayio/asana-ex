defmodule AsanaEx.ClientTest do
  use ExUnit.Case, async: true

  doctest AsanaEx.Client

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  test "builds Asana request for @me endpoint", %{bypass: bypass} do
    request = bypass.port
              |> endpoint_url()
              |> AsanaEx.Client.me()

    assert %Finch.Request{} = request
  end

  test "executes Asana request", %{bypass: bypass} do
    Bypass.expect(bypass, fn conn ->
      Plug.Conn.resp(conn, 200, "response body")
    end)

    response = bypass.port
               |> endpoint_url()
               |> AsanaEx.Client.me()
               |> AsanaEx.Client.execute()

    assert {:ok, %Finch.Response{}} = response
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
