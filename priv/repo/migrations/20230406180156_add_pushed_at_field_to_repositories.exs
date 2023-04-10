defmodule Beatrix.Repo.Migrations.AddPushedAtFieldToRepositories do
  use Ecto.Migration

  def change do
    alter table("repositories") do
      add :pushed_at, :utc_datetime
    end
  end
end
