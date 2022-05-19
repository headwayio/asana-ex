defmodule AsanaEx.Client.Host do
  @moduledoc """
  Host configuration module
  """

  @behaviour AsanaEx.Client.HostBehaviour

  @impl true
  def connect_url, do: "https://app.asana.com/api/1.0/"
end
