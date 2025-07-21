defmodule Filamentory.Repo.Migrations.CreateVariants do
  use Ecto.Migration

  def change do
    create table(:variants) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:variants, [:name])
  end
end
