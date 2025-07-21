defmodule FilamentoryWeb.MaterialControllerTest do
  use FilamentoryWeb.ConnCase

  import Filamentory.MaterialsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  describe "index" do
    test "lists all materials", %{conn: conn} do
      conn = get(conn, ~p"/materials")
      assert html_response(conn, 200) =~ "Listing Materials"
    end
  end

  describe "new material" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/materials/new")
      assert html_response(conn, 200) =~ "New Material"
    end
  end

  describe "create material" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/materials", material: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/materials/#{id}"

      conn = get(conn, ~p"/materials/#{id}")
      assert html_response(conn, 200) =~ "Material #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/materials", material: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Material"
    end
  end

  describe "edit material" do
    setup [:create_material]

    test "renders form for editing chosen material", %{conn: conn, material: material} do
      conn = get(conn, ~p"/materials/#{material}/edit")
      assert html_response(conn, 200) =~ "Edit Material"
    end
  end

  describe "update material" do
    setup [:create_material]

    test "redirects when data is valid", %{conn: conn, material: material} do
      conn = put(conn, ~p"/materials/#{material}", material: @update_attrs)
      assert redirected_to(conn) == ~p"/materials/#{material}"

      conn = get(conn, ~p"/materials/#{material}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, material: material} do
      conn = put(conn, ~p"/materials/#{material}", material: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Material"
    end
  end

  describe "delete material" do
    setup [:create_material]

    test "deletes chosen material", %{conn: conn, material: material} do
      conn = delete(conn, ~p"/materials/#{material}")
      assert redirected_to(conn) == ~p"/materials"

      assert_error_sent 404, fn ->
        get(conn, ~p"/materials/#{material}")
      end
    end
  end

  defp create_material(_) do
    material = material_fixture()
    %{material: material}
  end
end
