defmodule SiteChecker.DashboardControllerTest do
  use SiteChecker.ConnCase
  import SiteChecker.AccountUserSetup

  setup %{conn: conn} do
    setup_account_and_user
    {:ok, conn: conn}
  end

  test "As non logged in user /", %{conn: conn} do
    conn = get conn, dashboard_path(conn, :index)
    assert redirected_to(conn) == session_path(conn, :new)
  end

  test "As a logged in user /", %{conn: conn} do
    conn =
      conn
      |> post(session_path(conn, :create), session: login_attrs)
      |> get(dashboard_path(conn, :index))
    assert html_response(conn, 200) =~ "Dashboard"
  end
end
