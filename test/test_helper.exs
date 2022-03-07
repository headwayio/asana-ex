Mox.defmock(AsanaEx.MockClient, for: AsanaEx.ClientBehaviour)
Mox.defmock(AsanaEx.Client.MockHost, for: AsanaEx.Client.HostBehaviour)
Mox.defmock(AsanaEx.Client.MockHttp, for: AsanaEx.Client.HttpBehaviour)

Application.put_env(:asana_ex, :client, AsanaEx.Client.ClientBehaviour)
Application.put_env(:asana_ex, :client_host, AsanaEx.Client.MockHost)
Application.put_env(:asana_ex, :client_http, AsanaEx.Client.MockHttp)

ExUnit.start()
