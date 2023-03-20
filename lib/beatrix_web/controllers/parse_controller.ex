defmodule BeatrixWeb.ParseController do
  use BeatrixWeb, :controller

  def index(conn, _params) do
    a = HTTPoison.get! "https://api.github.com/search/repositories?q=more+useful+keyboard"
    render(conn, "parse.html")
  end
end
