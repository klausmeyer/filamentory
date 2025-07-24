defmodule Filamentory.SpoolsTest do
alias Filamentory.FilamentsFixtures
  use Filamentory.DataCase

  alias Filamentory.Spools

  describe "spools" do
    alias Filamentory.Spools.Spool

    import Filamentory.SpoolsFixtures

    @invalid_attrs %{comment: nil, ovp: nil, refill_only: nil, gross_weight_grams: nil}

    test "list_spools/0 returns all spools" do
      spool = spool_fixture()
      assert Enum.map(Spools.list_spools(), &(&1.id)) == [spool.id]
    end

    test "get_spool!/1 returns the spool with given id" do
      spool = spool_fixture()
      assert Spools.get_spool!(spool.id).id == spool.id
    end

    test "create_spool/1 with valid data creates a spool" do
      filament = FilamentsFixtures.filament_fixture()

      valid_attrs = %{filament_id: filament.id, comment: "some comment", ovp: true, refill_only: true, gross_weight_grams: 42}

      assert {:ok, %Spool{} = spool} = Spools.create_spool(valid_attrs)
      assert spool.comment == "some comment"
      assert spool.ovp == true
      assert spool.refill_only == true
      assert spool.gross_weight_grams == 42
    end

    test "create_spool/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Spools.create_spool(@invalid_attrs)
    end

    test "update_spool/2 with valid data updates the spool" do
      spool = spool_fixture()
      update_attrs = %{comment: "some updated comment", ovp: false, refill_only: false, gross_weight_grams: 43}

      assert {:ok, %Spool{} = spool} = Spools.update_spool(spool, update_attrs)
      assert spool.comment == "some updated comment"
      assert spool.ovp == false
      assert spool.refill_only == false
      assert spool.gross_weight_grams == 43
    end

    test "update_spool/2 with invalid data returns error changeset" do
      spool = spool_fixture()
      assert {:error, %Ecto.Changeset{}} = Spools.update_spool(spool, @invalid_attrs)
    end

    test "delete_spool/1 deletes the spool" do
      spool = spool_fixture()
      assert {:ok, %Spool{}} = Spools.delete_spool(spool)
      assert_raise Ecto.NoResultsError, fn -> Spools.get_spool!(spool.id) end
    end

    test "change_spool/1 returns a spool changeset" do
      spool = spool_fixture()
      assert %Ecto.Changeset{} = Spools.change_spool(spool)
    end
  end
end
