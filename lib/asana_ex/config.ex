defmodule AsanaEx.Config do
  @moduledoc """
  Utility that handles interaction with the application's configuration
  """

  @oauth_key_name :_asana_ex_oauth

  @spec get(:global | :process) :: any | nil
  def get(_scope \\ :process)
  def get(:global), do: Application.get_env(:asana_ex, :oauth, nil)
  def get(:process), do: Process.get(@oauth_key_name, nil)

  @spec set(any()) :: :ok
  @spec set(:process | :global, any()) :: :ok
  def set(value), do: set(:process, value)
  def set(:global, value), do: Application.put_env(:asana_ex, :oauth, value)

  def set(:process, value) do
    Process.put(@oauth_key_name, value)
    :ok
  end
end
