defmodule AsanaEx.API do
  alias AsanaEx.Config

  def supervisor_children do
    [
      {Finch, name: AsanaFinch, pools: get_pools()},
      {Task.Supervisor, name: AsanaEx.HttpSupervisor}
    ]
  end

  @spec get_pools() :: Keyword.t()
  defp get_pools() do
    Config.resolve(:pool_options, default: [size: 10])
  end
end
