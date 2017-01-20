defmodule SiteChecker.DashboardControllerTest do
  use SiteChecker.ConnCase

  test "As non logged in user /", %{conn: conn} do
    conn = get conn, dashboard_path(conn, :index)
    assert redirected_to(conn) == session_path(conn, :new)
  end
end
