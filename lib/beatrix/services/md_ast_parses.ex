defmodule Beatrix.Services.MdAstParses do
  require Logger

  def parse_save([]), do: Logger.info('Success!')

  def parse_save(list) do
    [head | tail] = list
    parse_save(tail, head)
  end

  def parse_save(tail, {"h2", [], [category_name], %{}}) do
    Logger.info("Find category: #{category_name}")
    parse_save(:category, category_name, tail)
  end

  def parse_save(tail, _) do
    parse_save(tail)
  end

  def parse_save(:category, category_name, list) do
    [_, head | _] = list
    {"ul", [], list_repos, %{}} = head
    parse_save(:repos, category_name, list_repos, list)
  end

  def parse_save(:repos, _category_name, [], processed_list) do
    parse_save(processed_list)
  end

  def parse_save(:repos, category_name, list_repos, processed_list) do
    [head | tail] = list_repos
    parse_save(:repo, category_name, head, tail, processed_list)
  end

  def parse_save(:repo, category_name, {"li", [], repo_data, %{}}, repos_tail, processed_list) do
    case repo_data do
      [{"a", [{"href", url}], [repo_name], %{}}, description | _] ->
        Logger.info(
          "Find. Cat: #{category_name} | url: #{url} | repo_name: #{repo_name} | description: #{description}"
        )

      [{"a", [{"href", url}], [repo_name], %{}} | _] ->
        Logger.info(
          "Find. Cat: #{category_name} | url: #{url} | repo_name: #{repo_name} | description: Unknown"
        )
      [{"p", [], [{"a", [{"href", url}], [repo_name], %{}}, description], %{}} | _] ->
        Logger.info(
          "Find. Cat: #{category_name} | url: #{url} | repo_name: #{repo_name} | description: #{description}"
        )
      _ ->
        Logger.warning(repo_data)
    end

    parse_save(:repos, category_name, repos_tail, processed_list)
  end

end


