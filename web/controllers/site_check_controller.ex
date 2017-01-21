defmodule SiteChecker.SiteCheckController do
  use SiteChecker.Web, :controller

  alias SiteChecker.SiteCheck

  def index(conn, _params) do
    site_checks = Repo.all(SiteCheck)
    render(conn, "index.html", site_checks: site_checks)
  end

  def new(conn, _params) do
    changeset = SiteCheck.changeset(%SiteCheck{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"site_check" => site_check_params}) do
    changeset = SiteCheck.changeset(%SiteCheck{}, site_check_params)

    case Repo.insert(changeset) do
      {:ok, _site_check} ->
        conn
        |> put_flash(:info, "Site check created successfully.")
        |> redirect(to: site_check_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    site_check = Repo.get!(SiteCheck, id)
    render(conn, "show.html", site_check: site_check)
  end

  def edit(conn, %{"id" => id}) do
    site_check = Repo.get!(SiteCheck, id)
    changeset = SiteCheck.changeset(site_check)
    render(conn, "edit.html", site_check: site_check, changeset: changeset)
  end

  def update(conn, %{"id" => id, "site_check" => site_check_params}) do
    site_check = Repo.get!(SiteCheck, id)
    changeset = SiteCheck.changeset(site_check, site_check_params)

    case Repo.update(changeset) do
      {:ok, site_check} ->
        conn
        |> put_flash(:info, "Site check updated successfully.")
        |> redirect(to: site_check_path(conn, :show, site_check))
      {:error, changeset} ->
        render(conn, "edit.html", site_check: site_check, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    site_check = Repo.get!(SiteCheck, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(site_check)

    conn
    |> put_flash(:info, "Site check deleted successfully.")
    |> redirect(to: site_check_path(conn, :index))
  end
end
