defmodule SiteChecker.DashboardController do
  use SiteChecker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
