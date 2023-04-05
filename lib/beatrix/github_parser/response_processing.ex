defmodule Beatrix.GithubParser.Processing do
  alias Beatrix.GithubParser.Github

  @awesome_elixir_readme_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

  def start do
    Github.get_awesome_list()
    |> Earmark.as_ast!()
    |> ResponseProcessing.parse_and_save()
  end
end

# Beatrix.ParseService.process_awesome_list
