defmodule Filamentory.FilamentsTest do
  use Filamentory.DataCase

  alias Filamentory.Filaments
  alias Filamentory.ProductsFixtures

  describe "filaments" do
    alias Filamentory.Filaments.Filament

    import Filamentory.FilamentsFixtures

    @invalid_attrs %{name: nil, product_id: nil, color_name: nil, color_hex: nil}

    test "list_filaments/0 returns all filaments" do
      filament = filament_fixture()
      assert Enum.map(Filaments.list_filaments(), & &1.id) == [filament.id]
    end

    test "get_filament!/1 returns the filament with given id" do
      filament = filament_fixture()
      assert Filaments.get_filament!(filament.id).id == filament.id
    end

    test "create_filament/1 with valid data creates a filament" do
      product = ProductsFixtures.product_fixture()

      valid_attrs = %{
        product_id: product.id,
        color_name: "some color_name",
        color_hex: "some color_hex"
      }

      assert {:ok, %Filament{} = filament} = Filaments.create_filament(valid_attrs)
      assert filament.color_name == "some color_name"
      assert filament.color_hex == "some color_hex"
    end

    test "create_filament/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Filaments.create_filament(@invalid_attrs)
    end

    test "update_filament/2 with valid data updates the filament" do
      filament = filament_fixture()
      update_attrs = %{color_name: "some updated color_name", color_hex: "some updated color_hex"}

      assert {:ok, %Filament{} = filament} = Filaments.update_filament(filament, update_attrs)
      assert filament.color_name == "some updated color_name"
      assert filament.color_hex == "some updated color_hex"
    end

    test "update_filament/2 with invalid data returns error changeset" do
      filament = filament_fixture()
      assert {:error, %Ecto.Changeset{}} = Filaments.update_filament(filament, @invalid_attrs)
    end

    test "delete_filament/1 deletes the filament" do
      filament = filament_fixture()
      assert {:ok, %Filament{}} = Filaments.delete_filament(filament)
      assert_raise Ecto.NoResultsError, fn -> Filaments.get_filament!(filament.id) end
    end

    test "change_filament/1 returns a filament changeset" do
      filament = filament_fixture()
      assert %Ecto.Changeset{} = Filaments.change_filament(filament)
    end
  end
end
