defmodule FilamentoryWeb.SpoolControllerTest do
  use FilamentoryWeb.ConnCase

  import Filamentory.FilamentsFixtures
  import Filamentory.SpoolsFixtures

  @create_attrs %{filament_id: nil, comment: "some comment", ovp: true, refill_only: true, gross_weight_grams: 42}
  @update_attrs %{comment: "some updated comment", ovp: false, refill_only: false, gross_weight_grams: 43}
  @invalid_attrs %{comment: nil, ovp: nil, refill_only: nil, gross_weight_grams: nil}

  describe "index" do
    test "lists all spools", %{conn: conn} do
      conn = get(conn, ~p"/spools")
      assert html_response(conn, 200) =~ "Listing Spools"
    end
  end

  describe "new spool" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/spools/new")
      assert html_response(conn, 200) =~ "New Spool"
    end
  end

  describe "create spool" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/spools", spool: %{@create_attrs | filament_id: filament_fixture().id})

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/spools/#{id}"

      conn = get(conn, ~p"/spools/#{id}")
      assert html_response(conn, 200) =~ "Spool #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/spools", spool: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Spool"
    end
  end

  describe "edit spool" do
    setup [:create_spool]

    test "renders form for editing chosen spool", %{conn: conn, spool: spool} do
      conn = get(conn, ~p"/spools/#{spool}/edit")
      assert html_response(conn, 200) =~ "Edit Spool"
    end
  end

  describe "update spool" do
    setup [:create_spool]

    test "redirects when data is valid", %{conn: conn, spool: spool} do
      conn = put(conn, ~p"/spools/#{spool}", spool: @update_attrs)
      assert redirected_to(conn) == ~p"/spools/#{spool}"

      conn = get(conn, ~p"/spools/#{spool}")
      assert html_response(conn, 200) =~ "some updated comment"
    end

    test "renders errors when data is invalid", %{conn: conn, spool: spool} do
      conn = put(conn, ~p"/spools/#{spool}", spool: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Spool"
    end
  end

  describe "delete spool" do
    setup [:create_spool]

    test "deletes chosen spool", %{conn: conn, spool: spool} do
      conn = delete(conn, ~p"/spools/#{spool}")
      assert redirected_to(conn) == ~p"/spools"

      assert_error_sent 404, fn ->
        get(conn, ~p"/spools/#{spool}")
      end
    end
  end

  defp create_spool(_) do
    spool = spool_fixture()
    %{spool: spool}
  end
end
