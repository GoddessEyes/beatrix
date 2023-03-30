defmodule Beatrix.Repo.Migrations.AddUniqueConstraintToRepositoriesUrl do
  use Ecto.Migration

  def change do
    create unique_index(:repositories, [:url])
  end
end
