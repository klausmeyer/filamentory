defmodule Filamentory.SpoolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Filamentory.Spools` context.
  """

  alias Filamentory.FilamentsFixtures

  @doc """
  Generate a spool.
  """
  def spool_fixture(attrs \\ %{}) do
    filament = FilamentsFixtures.filament_fixture()

    {:ok, spool} =
      attrs
      |> Enum.into(%{
        filament_id: filament.id,
        ovp: true,
        refill_only: true,
        gross_weight_grams: 420,
        comment: "some comment"
      })
      |> Filamentory.Spools.create_spool()

    spool
  end
end
