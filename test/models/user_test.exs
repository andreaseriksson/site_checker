defmodule SiteChecker.UserTest do
  use SiteChecker.ModelCase

  alias SiteChecker.User

  @valid_attrs %{name: "Some name", email: "some@email"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs, %{account_registration: false})
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs, %{account_registration: false})
    refute changeset.valid?
  end

  test "registration_changeset with valid attributes" do
    user = @valid_attrs
          |> Map.merge(%{
            password: "password",
            password_confirmation: "password"
          })
    changeset = User.changeset(%User{}, user)
    assert changeset.valid?
  end

  test "registration_changeset with unconfirmed password" do
    user = @valid_attrs
          |> Map.merge(%{
            password: "password",
            password_confirmation: "other password"
          })
    changeset = User.changeset(%User{}, user)
    refute changeset.valid?
  end

  test "registration_changeset with short password" do
    user = @valid_attrs
          |> Map.merge(%{
            password: "pass",
            password_confirmation: "pass"
          })
    changeset = User.changeset(%User{}, user)
    refute changeset.valid?
  end

  test "registration_changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
