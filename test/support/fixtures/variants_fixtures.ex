defmodule Filamentory.VariantsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Filamentory.Variants` context.
  """

  @doc """
  Generate a unique variant name.
  """
  def unique_variant_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a variant.
  """
  def variant_fixture(attrs \\ %{}) do
    {:ok, variant} =
      attrs
      |> Enum.into(%{
        name: unique_variant_name()
      })
      |> Filamentory.Variants.create_variant()

    variant
  end
end
