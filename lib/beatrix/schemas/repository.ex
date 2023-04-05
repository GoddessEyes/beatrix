defmodule Beatrix.Schemas.Repository do
  use Ecto.Schema
  alias Beatrix.Repo
  alias Ecto.Multi
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  schema "repositories" do
    field :description, :string
    field :repo_name, :string
    field :url, :string
    field :owner_name, :string
    field :star_count, :integer
    belongs_to :category, Beatrix.Category

    timestamps()
  end

  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:url, :repo_name, :description, :owner_name])
    |> validate_required([:url, :repo_name, :description])
  end

  def get_all_repos_owner_name do
    from(repo in "repositories", select: [repo.owner_name, repo.repo_name], limit: 2)
    |> Repo.all()
  end

  def bulk_update_star_count_by_name(list) do
    Enum.map(list, fn {repo_name, star_count} ->
      Repo.one(
        from repo in Beatrix.Schemas.Repository,
          where: fragment("lower(?)", repo.repo_name) == ^String.downcase(repo_name)
      )
      |> Ecto.Changeset.change(star_count: star_count)
      |> Repo.update()
    end)
  end

  def save_repository_link_to_category(repo_name, url, owner_name, description, category) do
    %Beatrix.Schemas.Repository{}
    |> Beatrix.Schemas.Repository.changeset(%{
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
