defmodule FilamentoryWeb.VariantControllerTest do
  use FilamentoryWeb.ConnCase

  import Filamentory.VariantsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all variants", %{conn: conn} do
      conn = get(conn, ~p"/variants")
      assert html_response(conn, 200) =~ "Listing Variants"
    end
  end

  describe "new variant" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/variants/new")
      assert html_response(conn, 200) =~ "New Variant"
    end
  end

  describe "create variant" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/variants", variant: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/variants/#{id}"

      conn = get(conn, ~p"/variants/#{id}")
      assert html_response(conn, 200) =~ "Variant #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/variants", variant: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Variant"
    end
  end

  describe "edit variant" do
    setup [:create_variant]

    test "renders form for editing chosen variant", %{conn: conn, variant: variant} do
      conn = get(conn, ~p"/variants/#{variant}/edit")
      assert html_response(conn, 200) =~ "Edit Variant"
    end
  end

  describe "update variant" do
    setup [:create_variant]

    test "redirects when data is valid", %{conn: conn, variant: variant} do
      conn = put(conn, ~p"/variants/#{variant}", variant: @update_attrs)
      assert redirected_to(conn) == ~p"/variants/#{variant}"

      conn = get(conn, ~p"/variants/#{variant}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, variant: variant} do
      conn = put(conn, ~p"/variants/#{variant}", variant: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Variant"
    end
  end

  describe "delete variant" do
    setup [:create_variant]

    test "deletes chosen variant", %{conn: conn, variant: variant} do
      conn = delete(conn, ~p"/variants/#{variant}")
      assert redirected_to(conn) == ~p"/variants"

      assert_error_sent 404, fn ->
        get(conn, ~p"/variants/#{variant}")
      end
    end
  end

  defp create_variant(_) do
    variant = variant_fixture()
    %{variant: variant}
  end
end
