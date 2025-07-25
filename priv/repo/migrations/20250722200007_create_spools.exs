defmodule Filamentory.Repo.Migrations.CreateSpools do
  use Ecto.Migration

  def change do
    create table(:spools) do
      add :name, :string
      add :filament_id, references(:filaments, on_delete: :nothing)
      add :ovp, :boolean, default: false, null: false
      add :refill_only, :boolean, default: false, null: false
      add :gross_weight_grams, :integer
      add :comment, :string

      timestamps(type: :utc_datetime)
    end

    create index(:spools, [:filament_id])
  end
end
