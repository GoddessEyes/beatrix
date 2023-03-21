defmodule Beatrix.ParseService do
  @awesome_elixir_readme_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

  def process_awesome_list do
    make_request_to_awesome_list() |> parse_markdown()
  end

  defp make_request_to_awesome_list do
    case HTTPoison.get(@awesome_elixir_readme_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp parse_markdown(response_body) do
    parsed_md = Md.parse(response_body)

  end
end
