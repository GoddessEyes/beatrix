defmodule BeatrixWeb.PageControllerTest do
  use BeatrixWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Awesome elixir"
  end
end
