defmodule Beatrix.Services.MdAstParses do
  require Logger
  alias Beatrix.Repo
  alias Beatrix.Category
  alias Beatrix.Repository

  def parse_save([]), do: Logger.info('Success!')

  def parse_save(list) do
    [head | tail] = list
    parse_save(tail, head)
  end

  def parse_save(tail, {"h2", [], [category_name], %{}}) do
    {result, changeset} =
      %Category{}
      |> Category.changeset(%{name: category_name})
      |> Repo.insert()

    case {result, changeset} do
      {:ok, changeset} ->
        Logger.info("Find and save category: #{changeset.name}")
        parse_save(:category, changeset, tail)

      {:error, _} ->
        category_instance = Repo.get_by(Category, name: category_name)
        Logger.info("Category: #{category_instance.name} already exist")
        parse_save(:category, category_instance, tail)
    end
  end

  def parse_save(tail, _) do
    parse_save(tail)
  end

  def parse_save(:category, category, list) do
    [_, head | _] = list
    {"ul", [], list_repos, %{}} = head
    parse_save(:repos, category, list_repos, list)
  end

  def parse_save(:repos, _category, [], processed_list) do
    parse_save(processed_list)
  end

  def parse_save(:repos, category, list_repos, processed_list) do
    [head | tail] = list_repos
    parse_save(:repo, category, head, tail, processed_list)
  end

  def parse_save(
        :repo,
        category,
        {"li", [], repo_data, %{}},
        repos_tail,
        processed_list
      ) do
    case repo_data do
      [{"a", [{"href", url}], [repo_name], %{}}, description | _] ->
        Logger.info(
          "Find. Cat: #{category.name} | url: #{url} | repo_name: #{repo_name} | description: #{description}"
        )

        repository_instance =
          Repo.get_by(Repository, repo_name: repo_name, category_id: category.id)

        case repository_instance do
          nil ->
            Logger.info("Repository does not exist. Creating")

          _ ->
            Logger.info("Repository exist. Skip")
            parse_save(:repos, category, repos_tail, processed_list)
        end

        {result, _} =
          %Repository{}
          |> Repository.changeset(%{
            description: description,
            repo_name: repo_name,
            url: url
          })
          |> Kernel.then(fn changeset -> changeset.changes end)
          |> Kernel.then(fn changes -> Ecto.build_assoc(category, :repositories, changes) end)
          |> Repo.insert()

        case result do
          :ok ->
            Logger.info(
              "Find and save. Cat: #{category.name} | url: #{url} | repo_name: #{repo_name} | description: #{description}"
            )

          :error ->
            Logger.info(
              "Already exist. Cat: #{category.name} | url: #{url} | repo_name: #{repo_name} | description: #{description}"
            )
        end

      _ ->
        Logger.warning(repo_data)
    end

    parse_save(:repos, category, repos_tail, processed_list)
  end
end

#      [{"a", [{"href", url}], [repo_name], %{}} | _] ->
#        Logger.info(
#          "Find. Cat: #{category_name} | url: #{url} | repo_name: #{repo_name} | description: Unknown"
#        )
#
#      [{"p", [], [{"a", [{"href", url}], [repo_name], %{}}, description], %{}} | _] ->
#        Logger.info(
#          "Find. Cat: #{category_name} | url: #{url} | repo_name: #{repo_name} | description: #{description}"
#        )
