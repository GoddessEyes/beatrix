defmodule Beatrix.Repo.Migrations.AddOwnerNameFieldToRepositories do
  use Ecto.Migration

  def change do
    alter table("repositories") do
      add :owner_name, :string
    end
  end
end
