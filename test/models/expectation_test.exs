defmodule SiteChecker.ExpectationTest do
  use SiteChecker.ModelCase

  alias SiteChecker.Expectation

  @valid_attrs %{identify_type: "some content", identify_value: "some content", match_content: "some content", match_type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Expectation.changeset(%Expectation{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Expectation.changeset(%Expectation{}, @invalid_attrs)
    refute changeset.valid?
  end
end
