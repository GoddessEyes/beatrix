defmodule Beatrix.Repository do
  use Ecto.Schema
  alias Beatrix.Repo

  import Ecto.Changeset

  schema "repositories" do
    field :description, :string
    field :repo_name, :string
    field :url, :string
    field :owner_name, :string
    belongs_to :category, Beatrix.Category

    timestamps()
  end

  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:url, :repo_name, :description, :owner_name])
    |> validate_required([:url, :repo_name, :description])
  end

  def save_repository_link_to_category(repo_name, url, owner_name, description, category) do
    %Beatrix.Repository{}
    |> Beatrix.Repository.changeset(%{
      repo_name: repo_name,
      url: url,
      owner_name: owner_name,
      description: description
    })
    |> Kernel.then(fn changeset -> changeset.changes end)
    |> Kernel.then(fn changes -> Ecto.build_assoc(category, :repositories, changes) end)
    |> Repo.insert()
  end
end
