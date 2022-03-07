defmodule AsanaEx.RequestHelpers do
  @type path :: binary()
  @type method :: Finch.Request.method()
  @type gid :: binary()

  @spec bypass_asana(number(), list({method(), path(), list(gid())})) ::
          {Agent.agent(), Bypass.t()}
  def bypass_asana(expect_count, response_fixture_filenames) do
    response_fixture_filenames
    |> Enum.each(fn {method, path, filenames} ->
      expect_count
      |> setup_bypass()
      |> bypass_expect(method, path, filenames)
    end)
  end

  def bypass_expect(bypass) do
    Bypass.expect(bypass, fn conn ->
      "{}"
    end)
  end

  def bypass_expect(bypass, method, path, filenames) do
    {:ok, agent} = Agent.start_link(fn -> filenames end)

    # require IEx; IEx.pry

    # IEx.Helpers.break!(Bypass.Plug.call/2)

    Bypass.expect(bypass, method, path, fn conn ->
      filenames = Agent.get(agent, fn content -> content end)
      {filenames, response} = build_response(filenames, conn)
      Agent.update(agent, fn _list -> filenames end)
      response
    end)

    {agent, bypass}
  end

  defp setup_bypass(expect_count) do
    bypass = Bypass.open()
    url = "http://localhost:#{bypass.port}/"
    Mox.expect(AsanaEx.Client.MockHost, :connect_url, expect_count, fn -> url end)
    bypass
  end

  def build_response([], conn), do: {[], Plug.Conn.resp(conn, 200, "{}")}

  def build_response([filename | tail], conn) do
    {tail, Plug.Conn.resp(conn, 200, fixture(filename))}
  end

  def fixture(filename) do
    (File.cwd!() <> "/test/fixtures/" <> filename)
    |> File.read!()
    |> Jason.decode!()
  end
end
