defmodule Filamentory.Spools.Spool do
  use Ecto.Schema
  import Ecto.Changeset

  alias Filamentory.Filaments
  alias Filamentory.Filaments.Filament
  alias Filamentory.Spools.Spool

  schema "spools" do
    field :name, :string
    belongs_to :filament, Filamentory.Filaments.Filament
    field :ovp, :boolean, default: false
    field :refill_only, :boolean, default: false
    field :gross_weight_grams, :integer
    field :remaining_weight_grams, :integer
    field :comment, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(spool, attrs) do
    spool
    |> cast(attrs, [:filament_id, :ovp, :refill_only, :gross_weight_grams, :comment])
    |> build_name
    |> update_remaining_weight
    |> validate_required([:name, :filament_id, :ovp, :refill_only])
    |> foreign_key_constraint(:filament_id)
  end

  defp build_name(%Ecto.Changeset{changes: %{filament_id: filament_id}} = changeset)
       when is_integer(filament_id) do
    filament_name = Filaments.get_filament!(filament_id).name

    changeset
    |> put_change(:name, filament_name)
  end

  defp build_name(changeset), do: changeset

  defp update_remaining_weight(
         %Ecto.Changeset{
           changes: %{gross_weight_grams: gross_weight_grams},
           data: %Spool{filament: %Filament{}} = spool
         } = changeset
       )
       when is_integer(gross_weight_grams) do
    changeset
    |> put_change(
      :remaining_weight_grams,
      gross_weight_grams - spool.filament.product.spool_weight_grams
    )
  end

  defp update_remaining_weight(changeset), do: changeset
end
