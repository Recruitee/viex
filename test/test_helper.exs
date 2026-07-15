Mox.defmock(Viex.HTTPClientMock, for: Viex.HTTPClient)
Application.put_env(:viex, :http_client, Viex.HTTPClientMock)

ExUnit.start()
