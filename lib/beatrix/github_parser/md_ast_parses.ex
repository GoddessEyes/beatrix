defmodule Beatrix.GithubParser.ResponseProcessing do
  require Logger
  alias Beatrix.Repo
  alias Beatrix.Schemas.Repository
  alias Beatrix.Schemas.Category

  def parse_and_save([]), do: Logger.info('Task finished')

  def parse_and_save(list) do
    [head | tail] = list
    parse_and_save(tail, head)
  end

  def parse_and_save(tail, {"h2", [], [category_name], %{}}) do
    {result, changeset} =
      %Category{}
      |> Category.changeset(%{name: category_name})
      |> Repo.insert()

    case {result, changeset} do
      {:ok, changeset} ->
        Logger.info('Category #{changeset.name} saved. Try parse repositories in category')
        parse_and_save(:category, changeset, tail)

      {:error, _} ->
        category_instance = Repo.get_by(Category, name: category_name)

        Logger.info(
          'Category #{category_instance.name} exist. Try parse repositories in category'
        )

        parse_and_save(:category, category_instance, tail)
    end
  end

  def parse_and_save(tail, _) do
    parse_and_save(tail)
  end

  def parse_and_save(:category, category, list) do
    [_, head | _] = list
    {"ul", [], list_repos, %{}} = head
    parse_and_save(:repos, category, list_repos, list)
  end

  def parse_and_save(:repos, _category, [], processed_list) do
    parse_and_save(processed_list)
  end

  def parse_and_save(:repos, category, list_repos, processed_list) do
    [head | tail] = list_repos
    parse_and_save(:repo, category, head, tail, processed_list)
  end

  def parse_and_save(
        :repo,
        category,
        {"li", [], repo_data, %{}},
        repos_tail,
        processed_list
      ) do
    case repo_data do
      [{"a", [{"href", url}], [repo_name], %{}}, description | _] ->
        owner_name = get_repo_owner(url)

        cond do
          owner_name === nil ->
            parse_and_save(:repos, category, repos_tail, processed_list)

          true ->
            repository_instance = Repo.get_by(Repository, repo_name: repo_name)

            case repository_instance do
              nil ->
                Repository.save_repository_link_to_category(
                  repo_name,
                  url,
                  owner_name,
                  description,
                  category
                )

                parse_and_save(:repos, category, repos_tail, processed_list)

              _ ->
                parse_and_save(:repos, category, repos_tail, processed_list)
            end
        end

      _ ->
        parse_and_save(:repos, category, repos_tail, processed_list)
    end
  end

  def get_repo_owner(github_url) do
    try do
      "https://github.com/" <> repo_own_url = github_url
      [owner_name, _] = String.split(repo_own_url, "/")
      owner_name
    rescue
      _ -> nil
    end
  end
end
