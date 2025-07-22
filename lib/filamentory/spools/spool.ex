defmodule Filamentory.Spools.Spool do
  use Ecto.Schema
  import Ecto.Changeset

  schema "spools" do
    belongs_to :filament, Filamentory.Filaments.Filament
    field :ovp, :boolean, default: false
    field :refill_only, :boolean, default: false
    field :gross_weight_grams, :integer
    field :comment, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(spool, attrs) do
    spool
    |> cast(attrs, [:filament_id, :ovp, :refill_only, :gross_weight_grams, :comment])
    |> validate_required([:filament_id, :ovp, :refill_only])
    |> foreign_key_constraint(:filament_id)
  end
end
