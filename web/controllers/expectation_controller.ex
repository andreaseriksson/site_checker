defmodule SiteChecker.ExpectationController do
  use SiteChecker.Web, :controller
  import SiteChecker.AppHelper
  alias SiteChecker.{Expectation, SiteCheck}

  def index(conn, %{"site_check_id" => site_check_id}) do
    site_check = load_site_check(conn, site_check_id)

    render(conn, "index.html", site_check: site_check, expectations: site_check.expectations, changeset: new_changeset)
  end

  def create(conn, %{"site_check_id" => site_check_id, "expectation" => expectation_params}) do
    changeset = load_site_check(conn, site_check_id)
    					  |> build_assoc(:expectations)
    						|> Expectation.changeset(expectation_params)

    case Repo.insert(changeset) do
      {:ok, _expectation} ->
        conn
        |> put_flash(:info, "Expectation created successfully.")
        |> redirect(to: site_check_expectation_path(conn, :index, site_check_id))
      {:error, changeset} ->
        site_check = load_site_check(conn, site_check_id)
        render(conn, "index.html", site_check: site_check, expectations: site_check.expectations, changeset: changeset)
    end
  end

  def update(conn, %{"site_check_id" => site_check_id, "id" => id, "expectation" => expectation_params}) do
    expectation = load_expectation(conn, site_check_id, id)
    changeset = Expectation.changeset(expectation, expectation_params)

    case Repo.update(changeset) do
      {:ok, expectation} ->
        conn
        |> put_flash(:info, "Expectation updated successfully.")
        |> redirect(to: site_check_expectation_path(conn, :index, expectation.site_check_id))
      {:error, changeset} ->
        # TODO: BREAKS ATM
        render(conn, "index.html", expectation: expectation, changeset: changeset)
    end
  end

  def delete(conn, %{"site_check_id" => site_check_id, "id" => id}) do
    expectation = load_expectation(conn, site_check_id, id)
    Repo.delete!(expectation)

    conn
    |> put_flash(:info, "Expectation deleted successfully.")
    |> redirect(to: site_check_expectation_path(conn, :index, expectation.site_check_id))
  end

  defp new_changeset do
    SiteChecker.Expectation.changeset(%SiteChecker.Expectation{})
  end

  defp load_expectation(conn, site_check_id, id) do
    site_check = load_site_check(conn, site_check_id)
    Repo.get_by!(Expectation, id: id, site_check_id: site_check.id)
  end

  defp load_site_check(conn, id) do
    account = current_account(conn)
    Repo.get_by!(SiteCheck, id: id, account_id: account.id)
    |> Repo.preload([expectations: (from s in Expectation, order_by: s.id)])
  end
end
