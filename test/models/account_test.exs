defmodule SiteChecker.AccountTest do
  use SiteChecker.ModelCase

  alias SiteChecker.Account

  @valid_attrs %{
    name: "some content",
    inactivated_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with valid user attributes" do
    account = @valid_attrs
              |> Map.merge(%{users: [%{
		              name: "Some name",
                  email: "some_email@example.com",
                  password: "abcdef",
                  password_confirmation: "abcdef"
                }]})

    changeset = Account.changeset(%Account{}, account)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid user attributes" do
    account = @valid_attrs
              |> Map.merge(%{users: [%{name: ""}]})

    changeset = Account.changeset(%Account{}, account)
    refute changeset.valid?
  end
end
