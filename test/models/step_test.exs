defmodule SiteChecker.StepTest do
  use SiteChecker.ModelCase

  alias SiteChecker.Step

  @valid_attrs %{action: "some content", identifier: "some content", selector: "some content", value: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Step.changeset(%Step{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Step.changeset(%Step{}, @invalid_attrs)
    refute changeset.valid?
  end
end
