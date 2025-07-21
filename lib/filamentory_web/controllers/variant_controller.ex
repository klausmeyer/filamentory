defmodule FilamentoryWeb.VariantController do
  use FilamentoryWeb, :controller

  alias Filamentory.Variants
  alias Filamentory.Variants.Variant

  def index(conn, _params) do
    variants = Variants.list_variants()
    render(conn, :index, variants: variants)
  end

  def new(conn, _params) do
    changeset = Variants.change_variant(%Variant{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"variant" => variant_params}) do
    case Variants.create_variant(variant_params) do
      {:ok, variant} ->
        conn
        |> put_flash(:info, "Variant created successfully.")
        |> redirect(to: ~p"/variants/#{variant}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    variant = Variants.get_variant!(id)
    render(conn, :show, variant: variant)
  end

  def edit(conn, %{"id" => id}) do
    variant = Variants.get_variant!(id)
    changeset = Variants.change_variant(variant)
    render(conn, :edit, variant: variant, changeset: changeset)
  end

  def update(conn, %{"id" => id, "variant" => variant_params}) do
    variant = Variants.get_variant!(id)

    case Variants.update_variant(variant, variant_params) do
      {:ok, variant} ->
        conn
        |> put_flash(:info, "Variant updated successfully.")
        |> redirect(to: ~p"/variants/#{variant}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, variant: variant, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    variant = Variants.get_variant!(id)
    {:ok, _variant} = Variants.delete_variant(variant)

    conn
    |> put_flash(:info, "Variant deleted successfully.")
    |> redirect(to: ~p"/variants")
  end
end
