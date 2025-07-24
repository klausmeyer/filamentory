defmodule Filamentory.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Filamentory.Products` context.
  """

  alias Filamentory.BrandsFixtures
  alias Filamentory.MaterialsFixtures
  alias Filamentory.VariantsFixtures

  @doc """
  Generate a unique product name.
  """
  def unique_product_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    brand = BrandsFixtures.brand_fixture()
    material = MaterialsFixtures.material_fixture()
    variant = VariantsFixtures.variant_fixture()

    {:ok, product} =
      attrs
      |> Enum.into(%{
        name: unique_product_name(),
        brand_id: brand.id,
        material_id: material.id,
        variant_id: variant.id,
        weight_grams: 1_000,
        spool_weight_grams: 250
      })
      |> Filamentory.Products.create_product()

    product
  end
end
