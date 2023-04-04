defmodule Beatrix.Repo.Migrations.AddStarCountFieldToRepository do
  use Ecto.Migration

  def change do
    alter table("repositories") do
      add :star_count, :integer
    end
  end
end
