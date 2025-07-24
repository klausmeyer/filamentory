defmodule Filamentory.FilamentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Filamentory.Filaments` context.
  """

  alias Filamentory.ProductsFixtures

  @doc """
  Generate a filament.
  """
  def filament_fixture(attrs \\ %{}) do
    product = ProductsFixtures.product_fixture()

    {:ok, filament} =
      attrs
      |> Enum.into(%{
        name: "some name",
        product_id: product.id,
        color_hex: "some color_hex",
        color_name: "some color_name"
      })
      |> Filamentory.Filaments.create_filament()

    filament
  end
end
