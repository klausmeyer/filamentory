defmodule Filamentory.FilamentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Filamentory.Filaments` context.
  """

  @doc """
  Generate a filament.
  """
  def filament_fixture(attrs \\ %{}) do
    {:ok, filament} =
      attrs
      |> Enum.into(%{
        color_hex: "some color_hex",
        color_name: "some color_name"
      })
      |> Filamentory.Filaments.create_filament()

    filament
  end
end
