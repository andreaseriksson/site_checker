defmodule SiteChecker.SiteCheckControllerTest do
  use SiteChecker.ConnCase

  import SiteChecker.AccountUserSetup
  import SiteChecker.AppHelper

  alias SiteChecker.SiteCheck
  @valid_attrs %{name: "some content", scheduled: true}
  @invalid_attrs %{}

  setup %{conn: conn} do
    setup_account_and_user
    conn = conn |> post(session_path(conn, :create), session: login_attrs)
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, site_check_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing site checks"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, site_check_path(conn, :new)
    assert html_response(conn, 200) =~ "New site check"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, site_check_path(conn, :create), site_check: @valid_attrs
    assert redirected_to(conn) == site_check_path(conn, :index)
    assert Repo.get_by(SiteCheck, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, site_check_path(conn, :create), site_check: @invalid_attrs
    assert html_response(conn, 200) =~ "New site check"
  end

  test "shows chosen resource", %{conn: conn} do
    site_check = Repo.insert! %SiteCheck{account_id: current_account(conn).id}
    conn = get conn, site_check_path(conn, :show, site_check)
    assert html_response(conn, 200) =~ "Show site check"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, site_check_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    site_check = Repo.insert! %SiteCheck{account_id: current_account(conn).id}
    conn = get conn, site_check_path(conn, :edit, site_check)
    assert html_response(conn, 200) =~ "Edit site check"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    site_check = Repo.insert! %SiteCheck{account_id: current_account(conn).id}
    conn = put conn, site_check_path(conn, :update, site_check), site_check: @valid_attrs
    assert redirected_to(conn) == site_check_path(conn, :show, site_check)
    assert Repo.get_by(SiteCheck, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    site_check = Repo.insert! %SiteCheck{account_id: current_account(conn).id}
    conn = put conn, site_check_path(conn, :update, site_check), site_check: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit site check"
  end

  test "deletes chosen resource", %{conn: conn} do
    site_check = Repo.insert! %SiteCheck{account_id: current_account(conn).id}
    conn = delete conn, site_check_path(conn, :delete, site_check)
    assert redirected_to(conn) == site_check_path(conn, :index)
    refute Repo.get(SiteCheck, site_check.id)
  end
end
