defmodule Beatrix.GithubParser.AwesomeParserTest do
  use Beatrix.DataCase
  alias Beatrix.GithubParser.AwesomeParser
  alias Beatrix.Repo
  alias Beatrix.Schemas.Category
  alias Beatrix.Schemas.Repository

  @awesome_elixir_response "
Description.

- [Some text](#some-link)
    - [Category](#category-link)

## TestCategory
*Some description.*
* [testrepo](https://github.com/testowner/testrepo) - Description.
* [Invalid repo](invalid-url) - Description
"

  test "Parse awesome-elixir response" do
    @awesome_elixir_response
    |> Earmark.as_ast!()
    |> AwesomeParser.parse_and_save()

    saved_category = Repo.get_by(Category, name: "TestCategory")
    saved_repository = Repo.get_by(Repository, repo_name: "testrepo")

    assert saved_category.name == "TestCategory"

    assert saved_repository.repo_name == "testrepo"
    assert saved_repository.description == " - Description."
    assert saved_repository.url == "https://github.com/testowner/testrepo"
    assert saved_repository.owner_name == "testowner"
  end
end
