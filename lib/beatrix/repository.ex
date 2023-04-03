defmodule Beatrix.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  schema "repositories" do
    field :description, :string
    field :repo_name, :string
    field :url, :string
    belongs_to :category, Beatrix.Category

    timestamps()
  end

  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:url, :repo_name, :description])
    |> validate_required([:url, :repo_name, :description])
  end
end
