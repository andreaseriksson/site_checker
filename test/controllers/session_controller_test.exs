defmodule SiteChecker.SessionControllerTest do
  use SiteChecker.ConnCase
  import SiteChecker.AccountUserSetup

  @invalid_attrs %{email: "", password: ""}

  setup %{conn: conn} do
    setup_account_and_user
    {:ok, conn: conn}
  end

  test "GET /signin", %{conn: conn} do
    conn = get conn, "/signin"
    assert html_response(conn, 200) =~ "Sign In"
  end

  test "creates session and redirects when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: login_attrs
    assert redirected_to(conn) == page_path(conn, :index)
    assert Guardian.Plug.current_resource(conn).email == "some_email@example.com"
  end

  test "displays signin page when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @invalid_attrs
    assert html_response(conn, 200) =~ "Sign in"
    refute Guardian.Plug.current_resource(conn)
  end

  test "logs out the user and destroys session and redirect to login", %{conn: conn} do
    conn =
      conn
      |> post(session_path(conn, :create), session: login_attrs)
      |> delete(session_path(conn, :destroy))

    assert redirected_to(conn) == session_path(conn, :new)
    refute Guardian.Plug.current_resource(conn)
  end
end
