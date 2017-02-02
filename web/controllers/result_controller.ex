defmodule SiteChecker.ResultController do
  use SiteChecker.Web, :controller
  import SiteChecker.AppHelper
  alias SiteChecker.{SiteCheck, Step, Expectation}

  def index(conn, %{"site_check_id" => site_check_id}) do
    site_check = load_site_check(conn, site_check_id)
    results = site_check |> SiteChecker.Check.start

    render conn, "index.js", site_check: site_check, results: results
  end

  defp load_site_check(conn, id) do
    account = current_account(conn)
    Repo.get_by!(SiteCheck, id: id, account_id: account.id)
    |> Repo.preload([steps: (from s in Step, order_by: s.id) ])
    |> Repo.preload([expectations: (from e in Expectation, order_by: e.id) ])
  end
end
