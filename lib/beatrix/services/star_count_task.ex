defmodule Beatrix.Services.StarCountTask do
  require Logger
  alias Beatrix.Repo
  import Ecto.Query, only: [from: 2]

  @github_token Application.compile_env(:beatrix, :token)

  def call_api_async(repo_url_list) do
    tasks =
      Task.async_stream(repo_url_list, fn url ->
        HTTPoison.get(url, Authorization: "Bearer #{@github_token}")
      end)

    Enum.into(tasks, [], fn {:ok, res} -> res end)
  end

  def get_all_repos do
    from(repo in "repositories", select: repo.url, limit: 2)
    |> Repo.all()
  end
end

# Beatrix.Services.StarCountTask.get_all_repos
# Beatrix.Services.StarCountTask.call_api_async
