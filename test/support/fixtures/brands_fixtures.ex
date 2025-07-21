defmodule Filamentory.BrandsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Filamentory.Brands` context.
  """

  @doc """
  Generate a unique brand name.
  """
  def unique_brand_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a brand.
  """
  def brand_fixture(attrs \\ %{}) do
    {:ok, brand} =
      attrs
      |> Enum.into(%{
        name: unique_brand_name()
      })
      |> Filamentory.Brands.create_brand()

    brand
  end
end
