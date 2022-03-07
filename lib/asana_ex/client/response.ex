defmodule AsanaEx.Client.Response do
  @type response :: AsanaEx.Types.response

  @doc """
  Convert Finch responses into JSON
  """
  def decode({:ok, %Finch.Response{} = response}), do: decode(response)

  def decode(%Finch.Response{body: body}), do: Jason.decode(body)
end
