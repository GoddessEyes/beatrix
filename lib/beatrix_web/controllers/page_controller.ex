defmodule BeatrixWeb.PageController do
  use BeatrixWeb, :controller
  alias Beatrix.Repo
  alias Beatrix.Category

  def index(conn, _params) do
    categories = Repo.all(Category) |> Repo.preload([:repositories])
    render(conn, "index.html", categories: categories)
  end
end
