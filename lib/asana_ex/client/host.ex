defmodule AsanaEx.Client.Host do
  @behavior AsanaEx.Client.HostBehaviour

  @impl true
  def connect_url, do: "https://app.asana.com/api/1.0/"
end
