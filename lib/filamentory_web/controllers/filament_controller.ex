defmodule FilamentoryWeb.FilamentController do
  use FilamentoryWeb, :controller

  alias Filamentory.Filaments
  alias Filamentory.Filaments.Filament

  def index(conn, _params) do
    filaments = Filaments.list_filaments()
    render(conn, :index, filaments: filaments)
  end

  def new(conn, _params) do
    changeset = Filaments.change_filament(%Filament{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"filament" => filament_params}) do
    case Filaments.create_filament(filament_params) do
      {:ok, filament} ->
        conn
        |> put_flash(:info, "Filament created successfully.")
        |> redirect(to: ~p"/filaments/#{filament}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    filament = Filaments.get_filament!(id)
    render(conn, :show, filament: filament)
  end

  def edit(conn, %{"id" => id}) do
    filament = Filaments.get_filament!(id)
    changeset = Filaments.change_filament(filament)
    render(conn, :edit, filament: filament, changeset: changeset)
  end

  def update(conn, %{"id" => id, "filament" => filament_params}) do
    filament = Filaments.get_filament!(id)

    case Filaments.update_filament(filament, filament_params) do
      {:ok, filament} ->
        conn
        |> put_flash(:info, "Filament updated successfully.")
        |> redirect(to: ~p"/filaments/#{filament}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, filament: filament, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    filament = Filaments.get_filament!(id)
    {:ok, _filament} = Filaments.delete_filament(filament)

    conn
    |> put_flash(:info, "Filament deleted successfully.")
    |> redirect(to: ~p"/filaments")
  end
end
