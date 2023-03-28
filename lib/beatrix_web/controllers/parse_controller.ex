defmodule BeatrixWeb.ParseController do
  use BeatrixWeb, :controller
  alias BeatrixWeb.ParseService, as: ParseService

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do

    ParseService.process_awesome_list()
    render(conn, "parse.html")
  end
end
