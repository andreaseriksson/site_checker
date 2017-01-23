defmodule SiteChecker.ReportTest do
  use SiteChecker.ModelCase

  alias SiteChecker.Report

  @valid_attrs %{status: "SUCCESS", data: %{}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Report.changeset(%Report{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Report.changeset(%Report{}, @invalid_attrs)
    refute changeset.valid?
  end
end
