defmodule Beatrix.GithubParser.Processing do
  alias Beatrix.GithubParser.Github
  alias Beatrix.Schemas.Repository
  alias Beatrix.GithubParser.ResponseProcessing

  def start do
    #    Github.get_awesome_list()
    #    |> Earmark.as_ast!()
    #    |> ResponseProcessing.parse_and_save()

    Repository.get_all_repos_owner_name()
    |> Github.build_repos_urls()
    |> Github.async_stream_for_repos_star_count()
    |> Repository.bulk_update_star_count_by_name()
  end
end

# Beatrix.GithubParser.Processing.start
