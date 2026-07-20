defmodule Viex.HTTPClient do
  @moduledoc false

  # Behaviour describing the slice of the HTTP client that Viex uses. The
  # default implementation is `HTTPoison`; tests inject a Mox mock instead.
  @callback post(
              url :: binary,
              body :: binary,
              headers :: list,
              options :: keyword
            ) :: {:ok, HTTPoison.Response.t()} | {:error, HTTPoison.Error.t()}
end
