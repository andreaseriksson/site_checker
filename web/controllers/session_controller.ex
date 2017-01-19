defmodule SiteChecker.SessionController do
  use SiteChecker.Web, :controller

  alias SiteChecker.Auth

  plug :put_layout, "session.html"

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    # TODO: Check if account is locked
    case Auth.login_by_email_and_password(conn, email, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Successfully logged in")
        |> redirect(to: "/")
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Wrong username/password")
        |> render("new.html")
    end
  end

  def destroy(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: "/signin")
  end
end
