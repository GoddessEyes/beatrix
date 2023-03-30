defmodule Beatrix.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :url, :string
      add :repo_name, :string
      add :description, :string
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:repositories, [:category_id])
  end
end
