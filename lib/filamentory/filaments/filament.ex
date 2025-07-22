defmodule Filamentory.Filaments.Filament do
  use Ecto.Schema
  import Ecto.Changeset

  schema "filaments" do
    belongs_to :product, Filamentory.Products.Product
    field :color_name, :string
    field :color_hex, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(filament, attrs) do
    filament
    |> cast(attrs, [:color_name, :color_hex])
    |> validate_required([:color_name, :color_hex])
    |> foreign_key_constraint(:product_id)
  end
end
