defmodule Filamentory.Variants.Variant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "variants" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(variant, attrs) do
    variant
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
