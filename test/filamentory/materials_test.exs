defmodule Filamentory.MaterialsTest do
  use Filamentory.DataCase

  alias Filamentory.Materials

  describe "materials" do
    alias Filamentory.Materials.Material

    import Filamentory.MaterialsFixtures

    @invalid_attrs %{name: nil}

    test "list_materials/0 returns all materials" do
      material = material_fixture()
      assert Materials.list_materials() == [material]
    end

    test "get_material!/1 returns the material with given id" do
      material = material_fixture()
      assert Materials.get_material!(material.id) == material
    end

    test "create_material/1 with valid data creates a material" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Material{} = material} = Materials.create_material(valid_attrs)
      assert material.name == "some name"
    end

    test "create_material/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Materials.create_material(@invalid_attrs)
    end

    test "update_material/2 with valid data updates the material" do
      material = material_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Material{} = material} = Materials.update_material(material, update_attrs)
      assert material.name == "some updated name"
    end

    test "update_material/2 with invalid data returns error changeset" do
      material = material_fixture()
      assert {:error, %Ecto.Changeset{}} = Materials.update_material(material, @invalid_attrs)
      assert material == Materials.get_material!(material.id)
    end

    test "delete_material/1 deletes the material" do
      material = material_fixture()
      assert {:ok, %Material{}} = Materials.delete_material(material)
      assert_raise Ecto.NoResultsError, fn -> Materials.get_material!(material.id) end
    end

    test "change_material/1 returns a material changeset" do
      material = material_fixture()
      assert %Ecto.Changeset{} = Materials.change_material(material)
    end
  end
end
