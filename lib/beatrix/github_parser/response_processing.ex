defmodule Beatrix.GithubParser.ResponseProcessing do
  @moduledoc """
  Entrypoint for parsing&save GitHub repos
  """
  alias Beatrix.GithubParser.GithubApiClient
  alias Beatrix.Schemas.Repository
  alias Beatrix.GithubParser.AwesomeParser

  def start_task do
    GithubApiClient.get_awesome_list()
    |> Earmark.as_ast!()
    |> AwesomeParser.parse_and_save()

    Repository.select_repos_owner_repo_name()
    |> GithubApiClient.build_repos_urls()
    |> GithubApiClient.async_stream_for_repos()
    |> Repository.bulk_update_star_count_pushed_at()
  end

  def start_command do
    start_task()
  end
end
