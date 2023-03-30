defmodule Beatrix.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  schema "repositories" do
    field :description, :string
    field :repo_name, :string
    field :url, :string
    field :category_id, :id

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:url, :repo_name, :description])
    |> validate_required([:url, :repo_name, :description])
    |> unique_constraint(:url)
  end
end
