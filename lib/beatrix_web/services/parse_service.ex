defmodule BeatrixWeb.ParseService do
  @awesome_elixir_readme_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

  def process_awesome_list do
    awesome_list_md = make_request(@awesome_elixir_readme_url)
    Earmark.as_ast!(awesome_list_md)
    # TODO: parse md ast
  end

  def make_request(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
