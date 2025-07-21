defmodule Filamentory.Materials.Material do
  use Ecto.Schema
  import Ecto.Changeset

  schema "materials" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(material, attrs) do
    material
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
