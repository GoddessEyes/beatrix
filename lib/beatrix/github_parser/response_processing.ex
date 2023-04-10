defmodule Beatrix.GithubParser.Processing do
  alias Beatrix.GithubParser.Github
  alias Beatrix.Schemas.Repository
  alias Beatrix.GithubParser.AwesomeParser

  def start do
    Github.get_awesome_list()
    |> Earmark.as_ast!()
    |> AwesomeParser.parse_and_save()

    Repository.select_repos_owner_repo_name()
    |> Github.build_repos_urls()
    |> Github.async_stream_for_repos()
    |> Repository.bulk_update_star_count_pushed_at()
  end
end
