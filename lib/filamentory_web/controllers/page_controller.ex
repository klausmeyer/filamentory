defmodule FilamentoryWeb.PageController do
  use FilamentoryWeb, :controller

  def home(conn, _params), do: redirect(conn, to: ~p"/spools")
end
