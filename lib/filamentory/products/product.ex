defmodule Filamentory.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    belongs_to :brand, Filamentory.Brands.Brand
    belongs_to :material, Filamentory.Materials.Material
    belongs_to :variant, Filamentory.Variants.Variant

    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:brand_id, :material_id, :variant_id, :name])
    |> validate_required([:brand_id, :material_id, :variant_id, :name])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:brand_id)
    |> foreign_key_constraint(:material_id)
    |> foreign_key_constraint(:variant_id)
  end
end
