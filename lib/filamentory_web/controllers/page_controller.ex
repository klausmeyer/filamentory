defmodule FilamentoryWeb.PageController do
  use FilamentoryWeb, :controller

  def home(conn, _params), do: render(conn, :home)
end
