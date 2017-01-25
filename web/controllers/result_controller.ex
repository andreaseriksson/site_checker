defmodule SiteChecker.ResultController do
  use SiteChecker.Web, :controller

  def index(conn, _params) do
    render conn, "index.js"
  end
end
