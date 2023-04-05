defmodule Beatrix.GithubParser.Github do
  use HTTPoison.Base
  @awesome_elixir_readme_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"
  @repo_url "https://api.github.com/repos/"
  @github_token Application.compile_env(:beatrix, :token)

  def async_stream_for_repos_star_count(repo_url_list) do
    tasks =
      Task.async_stream(repo_url_list, fn url ->
        HTTPoison.get(url, Authorization: "Bearer #{@github_token}")
      end)

    Enum.into(tasks, [], fn {:ok, res} ->
      {:ok, res} = res
      res.body
      |> Jason.decode!()
      |> Kernel.then(fn body -> {Map.fetch!(body, "name"), Map.fetch!(body, "stargazers_count")} end)
    end)
  end

  def build_repos_urls(list_repos) do
    Enum.map(list_repos, fn [owner_name, repository_name] -> build_repo_url(owner_name, repository_name) end)
  end

  def build_repo_url(owner_name, repository_name) do
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

# Beatrix.GithubParser.Github
