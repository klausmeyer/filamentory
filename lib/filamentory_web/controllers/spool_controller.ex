defmodule FilamentoryWeb.SpoolController do
  use FilamentoryWeb, :controller

  alias Filamentory.Spools
  alias Filamentory.Spools.Spool

  def index(conn, _params) do
    spools = Spools.list_spools()
    render(conn, :index, spools: spools, stats: Spools.get_stats())
  end

  def new(conn, _params) do
    changeset = Spools.change_spool(%Spool{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"spool" => spool_params}) do
    case Spools.create_spool(spool_params) do
      {:ok, spool} ->
        conn
        |> put_flash(:info, "Spool created successfully.")
        |> redirect(to: ~p"/spools/#{spool}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    spool = Spools.get_spool!(id)
    render(conn, :show, spool: spool)
  end

  def edit(conn, %{"id" => id}) do
    spool = Spools.get_spool!(id)
    changeset = Spools.change_spool(spool)
    render(conn, :edit, spool: spool, changeset: changeset)
  end

  def update(conn, %{"id" => id, "spool" => spool_params}) do
    spool = Spools.get_spool!(id)

    case Spools.update_spool(spool, spool_params) do
      {:ok, spool} ->
        conn
        |> put_flash(:info, "Spool updated successfully.")
        |> redirect(to: ~p"/spools/#{spool}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, spool: spool, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    spool = Spools.get_spool!(id)
    {:ok, _spool} = Spools.delete_spool(spool)

    conn
    |> put_flash(:info, "Spool deleted successfully.")
    |> redirect(to: ~p"/spools")
  end
end
