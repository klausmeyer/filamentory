defmodule Filamentory.SpoolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Filamentory.Spools` context.
  """

  @doc """
  Generate a spool.
  """
  def spool_fixture(attrs \\ %{}) do
    {:ok, spool} =
      attrs
      |> Enum.into(%{
        comment: "some comment",
        gross_weight_grams: 42,
        ovp: true,
        refill_only: true
      })
      |> Filamentory.Spools.create_spool()

    spool
  end
end
