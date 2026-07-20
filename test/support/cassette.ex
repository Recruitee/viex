defmodule Viex.Cassette do
  @moduledoc false

  # Loads a recorded response out of `fixture/vcr_cassettes/<name>.json` and
  # returns it as the `{:ok, %HTTPoison.Response{}}` tuple that `HTTPoison.post/4`
  # would have produced. Used to feed canned responses to the Mox HTTP mock.

  @dir "fixture/vcr_cassettes"

  def response(name) do
    [%{"response" => response}] =
      @dir
      |> Path.join("#{name}.json")
      |> File.read!()
      |> Jason.decode!()

    {:ok,
     %HTTPoison.Response{
       status_code: response["status_code"],
       body: response["body"],
       headers: Map.to_list(response["headers"])
     }}
  end
end
