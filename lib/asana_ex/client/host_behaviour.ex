defmodule AsanaEx.Client.HostBehaviour do
  @callback connect_url() :: String.t()
end
