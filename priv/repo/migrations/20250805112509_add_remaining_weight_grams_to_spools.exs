defmodule Filamentory.Repo.Migrations.AddRemainingWeightGramsToSpools do
  use Ecto.Migration

  def change do
    alter table("spools") do
      add :remaining_weight_grams, :integer, null: false, default: 0
    end
  end
end
