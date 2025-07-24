defmodule Filamentory.ProductsTest do
  use Filamentory.DataCase

  alias Filamentory.Products

  import Filamentory.VariantsFixtures
  import Filamentory.MaterialsFixtures
  import Filamentory.BrandsFixtures

  describe "products" do
    alias Filamentory.Products.Product

    import Filamentory.ProductsFixtures

    @invalid_attrs %{name: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Enum.map(Products.list_products(), & &1.id) == [product.id]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id).id == product.id
    end

    test "create_product/1 with valid data creates a product" do
      brand = brand_fixture()
      material = material_fixture()
      variant = variant_fixture()

      valid_attrs = %{
        name: "some name",
        brand_id: brand.id,
        material_id: material.id,
        variant_id: variant.id,
        weight_grams: 1_000,
        spool_weight_grams: 250
      }

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.name == "some name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.name == "some updated name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product.id == Products.get_product!(product.id).id
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
