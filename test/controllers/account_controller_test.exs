defmodule SiteChecker.AccountControllerTest do
  use SiteChecker.ConnCase

  alias SiteChecker.{Account, User}
  @valid_attrs %{name: "some content", users: %{"0" => %{
		name: "Some name", email: "some_email@example.com", password: "abcdef", password_confirmation: "abcdef"
	}}}
  @invalid_attrs %{users: %{}}

  test "GET /signup", %{conn: conn} do
    conn = get conn, "/signup"
    assert html_response(conn, 200) =~ "Create Account"
  end

	test "creates resource and redirects when data is valid", %{conn: conn} do
		conn = post conn, account_path(conn, :create), account: @valid_attrs
		assert redirected_to(conn) == dashboard_path(conn, :index)
		assert Repo.get_by(Account, name: @valid_attrs[:name])
		assert Repo.get_by(User, email: @valid_attrs[:users]["0"][:email])
	end

	test "does not create resource and renders errors when data is invalid", %{conn: conn} do
		conn = post conn, account_path(conn, :create), account: @invalid_attrs
		assert html_response(conn, 200) =~ "Create Account"
	end

  #test "renders form for editing chosen resource", %{conn: conn} do
  #  account = Repo.insert! %Account{}
  #  conn = get conn, account_path(conn, :edit, account)
  #  assert html_response(conn, 200) =~ "Edit page test"
  #end
end
