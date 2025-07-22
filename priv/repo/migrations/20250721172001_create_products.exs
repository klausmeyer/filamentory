defmodule Filamentory.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :brand_id, references(:brands, on_delete: :nothing)
      add :material_id, references(:materials, on_delete: :nothing)
      add :variant_id, references(:variants, on_delete: :nothing)
      add :spool_weight_grams, :integer
      add :weight_grams, :integer

      timestamps(type: :utc_datetime)
    end

    create unique_index(:products, [:name])
    create index(:products, [:brand_id])
    create index(:products, [:material_id])
    create index(:products, [:variant_id])
  end
end
