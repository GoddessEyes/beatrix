defmodule Beatrix.GithubParser.Processing do
  alias Beatrix.GithubParser.Github
  alias Beatrix.Repo
  alias Beatrix.Schemas.Repository
  alias Beatrix.GithubParser.ResponseProcessing

  @awesome_elixir_readme_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

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
