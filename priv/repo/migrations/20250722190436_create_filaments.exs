defmodule Filamentory.Repo.Migrations.CreateFilaments do
  use Ecto.Migration

  def change do
    create table(:filaments) do
      add :name, :string
      add :product_id, references(:products, on_delete: :nothing)
      add :color_name, :string
      add :color_hex, :string

      timestamps(type: :utc_datetime)
    end

    create index(:filaments, [:product_id])
  end
end
