defmodule Filamentory.VariantsTest do
  use Filamentory.DataCase

  alias Filamentory.Variants

  describe "variants" do
    alias Filamentory.Variants.Variant

    import Filamentory.VariantsFixtures

    @invalid_attrs %{name: nil}

    test "list_variants/0 returns all variants" do
      variant = variant_fixture()
      assert Variants.list_variants() == [variant]
    end

    test "get_variant!/1 returns the variant with given id" do
      variant = variant_fixture()
      assert Variants.get_variant!(variant.id) == variant
    end

    test "create_variant/1 with valid data creates a variant" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Variant{} = variant} = Variants.create_variant(valid_attrs)
      assert variant.name == "some name"
    end

    test "create_variant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Variants.create_variant(@invalid_attrs)
    end

    test "update_variant/2 with valid data updates the variant" do
      variant = variant_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Variant{} = variant} = Variants.update_variant(variant, update_attrs)
      assert variant.name == "some updated name"
    end

    test "update_variant/2 with invalid data returns error changeset" do
      variant = variant_fixture()
      assert {:error, %Ecto.Changeset{}} = Variants.update_variant(variant, @invalid_attrs)
      assert variant == Variants.get_variant!(variant.id)
    end

    test "delete_variant/1 deletes the variant" do
      variant = variant_fixture()
      assert {:ok, %Variant{}} = Variants.delete_variant(variant)
      assert_raise Ecto.NoResultsError, fn -> Variants.get_variant!(variant.id) end
    end

    test "change_variant/1 returns a variant changeset" do
      variant = variant_fixture()
      assert %Ecto.Changeset{} = Variants.change_variant(variant)
    end
  end
end
