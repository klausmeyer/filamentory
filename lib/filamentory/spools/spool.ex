defmodule Filamentory.Spools.Spool do
  use Ecto.Schema
  import Ecto.Changeset

  alias Filamentory.Filaments

  schema "spools" do
    field :name, :string
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
    |> build_name
    |> validate_required([:name, :filament_id, :ovp, :refill_only])
    |> foreign_key_constraint(:filament_id)
  end

  defp build_name(%Ecto.Changeset{changes: %{filament_id: filament_id}} = changeset)
       when is_integer(filament_id) do
    filament_name = Filaments.get_filament!(filament_id).name

    put_change(changeset, :name, filament_name)
  end

  defp build_name(changeset) do
    changeset
  end
end
