defmodule Filamentory.Brands.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  schema "brands" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
