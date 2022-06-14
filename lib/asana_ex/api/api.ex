defmodule AsanaEx.API do
  @moduledoc """
  AsanaEx.API module
  """

  def supervisor_children do
    [
      {Finch, name: AsanaFinch, pools: get_pools()},
      {Task.Supervisor, name: AsanaEx.HttpSupervisor}
    ]
  end

  @spec get_pools() :: Keyword.t()
  defp get_pools() do
    Application.get_env(:asana_ex, :pool_options, default: [size: 10])
  end
end
