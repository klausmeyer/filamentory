defmodule FilamentoryWeb.BrandController do
  use FilamentoryWeb, :controller

  alias Filamentory.Brands
  alias Filamentory.Brands.Brand

  def index(conn, _params) do
    brands = Brands.list_brands()
    render(conn, :index, brands: brands)
  end

  def new(conn, _params) do
    changeset = Brands.change_brand(%Brand{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"brand" => brand_params}) do
    case Brands.create_brand(brand_params) do
      {:ok, brand} ->
        conn
        |> put_flash(:info, "Brand created successfully.")
        |> redirect(to: ~p"/brands/#{brand}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    brand = Brands.get_brand!(id)
    render(conn, :show, brand: brand)
  end

  def edit(conn, %{"id" => id}) do
    brand = Brands.get_brand!(id)
    changeset = Brands.change_brand(brand)
    render(conn, :edit, brand: brand, changeset: changeset)
  end

  def update(conn, %{"id" => id, "brand" => brand_params}) do
    brand = Brands.get_brand!(id)

    case Brands.update_brand(brand, brand_params) do
      {:ok, brand} ->
        conn
        |> put_flash(:info, "Brand updated successfully.")
        |> redirect(to: ~p"/brands/#{brand}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, brand: brand, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    brand = Brands.get_brand!(id)
    {:ok, _brand} = Brands.delete_brand(brand)

    conn
    |> put_flash(:info, "Brand deleted successfully.")
    |> redirect(to: ~p"/brands")
  end
end
