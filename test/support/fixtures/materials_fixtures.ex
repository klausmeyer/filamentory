defmodule Filamentory.MaterialsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Filamentory.Materials` context.
  """

  @doc """
  Generate a unique material name.
  """
  def unique_material_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a material.
  """
  def material_fixture(attrs \\ %{}) do
    {:ok, material} =
      attrs
      |> Enum.into(%{
        name: unique_material_name()
      })
      |> Filamentory.Materials.create_material()

    material
  end
end
