defmodule BeatrixWeb.PageController do
  use BeatrixWeb, :controller
  alias Beatrix.Repo
  alias Beatrix.Schemas.Category
  import Ecto.Query, only: [from: 2]

  def index(conn, params) do
    min_stars = Map.get(params, "min_stars", 0)

    query =
      from c in Category,
        join: r in assoc(c, :repositories),
        preload: [repositories: r],
        where: r.star_count > ^min_stars

    categories = Repo.all(query)
    render(conn, "index.html", categories: categories)
  end
end
