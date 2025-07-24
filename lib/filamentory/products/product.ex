defmodule Filamentory.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    belongs_to :brand, Filamentory.Brands.Brand
    belongs_to :material, Filamentory.Materials.Material
    belongs_to :variant, Filamentory.Variants.Variant
    field :weight_grams, :integer
    field :spool_weight_grams, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [
      :brand_id,
      :material_id,
      :variant_id,
      :name,
      :weight_grams,
      :spool_weight_grams
    ])
    |> validate_required([
      :brand_id,
      :material_id,
      :variant_id,
      :name,
      :weight_grams,
      :spool_weight_grams
    ])
    |> unique_constraint(:name)
    |> foreign_key_constraint(:brand_id)
    |> foreign_key_constraint(:material_id)
    |> foreign_key_constraint(:variant_id)
  end
end
