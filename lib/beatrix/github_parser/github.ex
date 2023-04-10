defmodule Beatrix.GithubParser.Github do
  use HTTPoison.Base

  @awesome_elixir_readme_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"
  @repo_url "https://api.github.com/repos/"
  @github_token Application.compile_env(:beatrix, :token)

  def async_stream_for_repos_star_count(repo_url_list) do
    IO.puts(@github_token)

    repo_url_list
    |> Task.async_stream(&make_auth_request_for_start_count/1,
      max_concurrency: 500,
      timeout: 20000
    )
    |> Enum.into([], fn {:ok,
                         [id, %{"pushed_at" => pushed_at, "stargazers_count" => stargazers_count}]} ->
      [id, {pushed_at, stargazers_count}]
    end)
  end

  def make_auth_request_for_start_count([id, url]) do
    case HTTPoison.get(url, [Authorization: "Bearer #{@github_token}"], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        repo_data =
          body
          |> Jason.decode!()
          |> Map.take(["stargazers_count", "pushed_at"])

        [id, repo_data]

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        [id, %{"pushed_at" => nil, "stargazers_count" => 0}]

      {:error, %HTTPoison.Error{reason: _}} ->
        [id, %{"pushed_at" => nil, "stargazers_count" => 0}]
    end
  end

  def build_repos_urls(list_repos) do
    Enum.map(list_repos, fn [id, owner, name] -> [id, build_repo_url([owner, name])] end)
  end

  def build_repo_url([owner_name, repository_name]) do
    @repo_url <> owner_name <> "/" <> repository_name
  end

  def get_awesome_list() do
    case HTTPoison.get(@awesome_elixir_readme_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
