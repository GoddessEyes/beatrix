defmodule BeatrixWeb.Services.MdAstParses do

  def get_entity([]), do: nil

  def get_entity(list) do
    [head | tail] = list
    get_entity(tail, head)
  end

  def get_entity(tail, {"h2", [], [category_name], %{}}) do
    IO.puts category_name
    get_entity(:category, category_name, tail)
  end

  def get_entity(:category, category_name, list) do
    [_ | tail] = list
    [head | tail] = tail
    {"ul", [], list_repos, %{}} = head
    get_entity(:repos, category_name, list_repos, list)
  end

  def get_entity(:repos, category_name, [], processed_list) do
    get_entity(processed_list)
  end

  def get_entity(:repos, category_name, list_repos, processed_list) do
    [head | tail] = list_repos
    get_entity(:repo, category_name, head, tail, processed_list)
  end

  def get_entity(:repo, category_name, {"li", [], repo_data, %{}}, repos_tail, processed_list) do
    case repo_data do
      [{"a", [{"href", url}], [repo_name], %{}}, description | tail] ->
        IO.puts "Cat: #{category_name} | url: #{url} | repo_name: #{repo_name} | description: #{description}"
      [{"a", [{"href", url}], [repo_name], %{}} | tail] ->
        IO.puts "Cat: #{category_name} | url: #{url} | repo_name: #{repo_name} | description: Unkown"
      _ -> IO.puts "Parsing not possible"
    end
    get_entity(:repos, category_name, repos_tail, processed_list)
  end

  def get_entity(tail, _) do
    get_entity(tail)
  end

end
