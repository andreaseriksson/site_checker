defmodule SiteChecker.DashboardController do
  use SiteChecker.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: SiteChecker.ErrorHandler

  def index(conn, _params) do
    render conn, "index.html"
  end
end
