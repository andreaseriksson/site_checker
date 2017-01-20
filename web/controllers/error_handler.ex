defmodule SiteChecker.ErrorHandler do
  use SiteChecker.Web, :controller

  @doc """
  Called automatically by the line `plug Guardian.Plug.EnsureAuthenticated, handler: SiteChecker.Auth`
  in the router.
  """
  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Not logged in")
    |> redirect(to: session_path(conn, :new))
  end

  def unauthorized(conn, _params) do
    conn
    |> put_flash(:error, "Not logged in")
    |> redirect(to: session_path(conn, :new))
  end
end
