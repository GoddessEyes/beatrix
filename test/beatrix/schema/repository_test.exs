defmodule Beatrix.Schemas.RepositoryTest do
  use Beatrix.DataCase
  alias Beatrix.Repo
  alias Beatrix.Schemas.Category
  alias Beatrix.Schemas.Repository

  test "Repository.save_repository_link_to_category" do
    {_, category} =
      %Category{}
      |> Category.changeset(%{name: "test_category"})
      |> Repo.insert()

    {result, repository} =
      Repository.save_repository_link_to_category(
        "test_repo_name",
        "http://test_repo.url",
        "test_owner_name",
        "test_description",
        category
      )

    assert result == :ok
    assert is_integer(repository.id)
  end

  test "Repository.bulk_update_star_count_pushed_at pushed_at not nil" do
    pushed_at_str = "2023-01-23T23:50:07Z"
    {:ok, pushed_at, _} = DateTime.from_iso8601(pushed_at_str)
    star_count = 10

    {:ok, repository} =
      %Repository{}
      |> Repository.changeset(%{
        repo_name: "test_repo_name",
        url: "http://test_repo.url",
        owner_name: "test_owner_name",
        description: "test_description"
      })
      |> Repo.insert()

    [ok: updated_repo] =
      Repository.bulk_update_star_count_pushed_at([[repository.id, {pushed_at_str, star_count}]])

    assert updated_repo.star_count == star_count
    assert updated_repo.pushed_at == pushed_at
  end

  test "Repository.bulk_update_star_count_pushed_at pushed_at is nil" do
    star_count = 10

    {:ok, repository} =
      %Repository{}
      |> Repository.changeset(%{
        repo_name: "test_repo_name",
        url: "http://test_repo.url",
        owner_name: "test_owner_name",
        description: "test_description"
      })
      |> Repo.insert()

    [ok: updated_repo] =
      Repository.bulk_update_star_count_pushed_at([[repository.id, {nil, star_count}]])

    assert updated_repo.star_count == star_count
    assert updated_repo.pushed_at == nil
  end

  test "Repository.select_repos_owner_repo_name" do
    {:ok, repository} =
      %Repository{}
      |> Repository.changeset(%{
        repo_name: "test_repo_name",
        url: "http://test_repo.url",
        owner_name: "test_owner_name",
        description: "test_description"
      })
      |> Repo.insert()

    repos = Repository.select_repos_owner_repo_name()
    [[repo_id, repo_owner, repo_name] | _] = repos

    assert repo_id == repository.id
    assert repo_owner == repository.owner_name
    assert repo_name == repository.repo_name
  end
end
