defmodule SiteChecker.SiteCheckTest do
  use SiteChecker.ModelCase

  alias SiteChecker.SiteCheck

  @valid_attrs %{name: "some content", scheduled: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SiteCheck.changeset(%SiteCheck{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SiteCheck.changeset(%SiteCheck{}, @invalid_attrs)
    refute changeset.valid?
  end
end
