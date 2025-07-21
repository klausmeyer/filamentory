defmodule Filamentory.Repo.Migrations.CreateBrands do
  use Ecto.Migration

  def change do
    create table(:brands) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:brands, [:name])
  end
end
