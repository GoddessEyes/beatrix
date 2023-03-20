defmodule Beatrix.ParseService do
  @awesome_elixir_readme_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

  def process_awesome_list do
    awesome_list = make_request_to_awesome_list()
    parse_markdown(awesome_list)
  end

  defp make_request_to_awesome_list do
    HTTPoison.get!(@awesome_elixir_readme_url)
  end

  defp parse_markdown(markdown) do
    {:ok, ast, []} = EarmarkParser.as_ast(markdown.body)
    as = 1
  end

end
