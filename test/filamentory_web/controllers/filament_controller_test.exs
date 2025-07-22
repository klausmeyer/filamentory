defmodule FilamentoryWeb.FilamentControllerTest do
  use FilamentoryWeb.ConnCase

  import Filamentory.FilamentsFixtures

  @create_attrs %{color_name: "some color_name", color_hex: "some color_hex"}
  @update_attrs %{color_name: "some updated color_name", color_hex: "some updated color_hex"}
  @invalid_attrs %{color_name: nil, color_hex: nil}

  describe "index" do
    test "lists all filaments", %{conn: conn} do
      conn = get(conn, ~p"/filaments")
      assert html_response(conn, 200) =~ "Listing Filaments"
    end
  end

  describe "new filament" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/filaments/new")
      assert html_response(conn, 200) =~ "New Filament"
    end
  end

  describe "create filament" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/filaments", filament: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/filaments/#{id}"

      conn = get(conn, ~p"/filaments/#{id}")
      assert html_response(conn, 200) =~ "Filament #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/filaments", filament: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Filament"
    end
  end

  describe "edit filament" do
    setup [:create_filament]

    test "renders form for editing chosen filament", %{conn: conn, filament: filament} do
      conn = get(conn, ~p"/filaments/#{filament}/edit")
      assert html_response(conn, 200) =~ "Edit Filament"
    end
  end

  describe "update filament" do
    setup [:create_filament]

    test "redirects when data is valid", %{conn: conn, filament: filament} do
      conn = put(conn, ~p"/filaments/#{filament}", filament: @update_attrs)
      assert redirected_to(conn) == ~p"/filaments/#{filament}"

      conn = get(conn, ~p"/filaments/#{filament}")
      assert html_response(conn, 200) =~ "some updated color_name"
    end

    test "renders errors when data is invalid", %{conn: conn, filament: filament} do
      conn = put(conn, ~p"/filaments/#{filament}", filament: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Filament"
    end
  end

  describe "delete filament" do
    setup [:create_filament]

    test "deletes chosen filament", %{conn: conn, filament: filament} do
      conn = delete(conn, ~p"/filaments/#{filament}")
      assert redirected_to(conn) == ~p"/filaments"

      assert_error_sent 404, fn ->
        get(conn, ~p"/filaments/#{filament}")
      end
    end
  end

  defp create_filament(_) do
    filament = filament_fixture()
    %{filament: filament}
  end
end
