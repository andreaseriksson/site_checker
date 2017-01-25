defmodule SiteChecker.SiteCheckTest do
  use SiteChecker.ModelCase

  alias SiteChecker.SiteCheck

  @valid_attrs %{name: "some content", url: "http://www.example.com", scheduled: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SiteCheck.changeset(%SiteCheck{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SiteCheck.changeset(%SiteCheck{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid url" do
    changeset = SiteCheck.changeset(%SiteCheck{}, %{name: "some content", url: "invalid url", scheduled: true})
    refute changeset.valid?
  end
end
