defmodule Filamentory.Filaments.Filament do
  use Ecto.Schema
  import Ecto.Changeset

  alias Filamentory.Products

  schema "filaments" do
    belongs_to :product, Filamentory.Products.Product
    field :color_name, :string
    field :color_hex, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(filament, attrs) do
    filament
    |> cast(attrs, [:product_id, :color_name, :color_hex])
    |> build_name
    |> validate_required([:name, :product_id, :color_name, :color_hex])
    |> foreign_key_constraint(:product_id)
  end

  defp build_name(changeset) do
    product_name = Products.get_product!(get_field(changeset, :product_id)).name
    color_name   = get_field(changeset, :color_name)

    put_change(changeset, :name, "#{product_name} - #{color_name}")
  end
end
