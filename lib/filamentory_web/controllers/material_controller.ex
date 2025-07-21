defmodule FilamentoryWeb.MaterialController do
  use FilamentoryWeb, :controller

  alias Filamentory.Materials
  alias Filamentory.Materials.Material

  def index(conn, _params) do
    materials = Materials.list_materials()
    render(conn, :index, materials: materials)
  end

  def new(conn, _params) do
    changeset = Materials.change_material(%Material{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"material" => material_params}) do
    case Materials.create_material(material_params) do
      {:ok, material} ->
        conn
        |> put_flash(:info, "Material created successfully.")
        |> redirect(to: ~p"/materials/#{material}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    material = Materials.get_material!(id)
    render(conn, :show, material: material)
  end

  def edit(conn, %{"id" => id}) do
    material = Materials.get_material!(id)
    changeset = Materials.change_material(material)
    render(conn, :edit, material: material, changeset: changeset)
  end

  def update(conn, %{"id" => id, "material" => material_params}) do
    material = Materials.get_material!(id)

    case Materials.update_material(material, material_params) do
      {:ok, material} ->
        conn
        |> put_flash(:info, "Material updated successfully.")
        |> redirect(to: ~p"/materials/#{material}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, material: material, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    material = Materials.get_material!(id)
    {:ok, _material} = Materials.delete_material(material)

    conn
    |> put_flash(:info, "Material deleted successfully.")
    |> redirect(to: ~p"/materials")
  end
end
