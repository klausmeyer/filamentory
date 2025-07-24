defmodule FilamentoryWeb.PageControllerTest do
  use FilamentoryWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn) == ~p"/spools"
  end
end
