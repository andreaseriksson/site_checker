defmodule SiteChecker.StepController do
  use SiteChecker.Web, :controller
  import SiteChecker.AppHelper
  alias SiteChecker.{Step, SiteCheck}

  def index(conn, %{"site_check_id" => site_check_id}) do
    site_check = load_site_check(conn, site_check_id)

    render(conn, "index.html", site_check: site_check, steps: site_check.steps, changeset: new_changeset)
  end

  def create(conn, %{"site_check_id" => site_check_id, "step" => step_params}) do
    changeset = load_site_check(conn, site_check_id)
    					  |> build_assoc(:steps)
    						|> Step.changeset(step_params)

    case Repo.insert(changeset) do
      {:ok, _step} ->
        conn
        |> put_flash(:info, "Step created successfully.")
        |> redirect(to: site_check_step_path(conn, :index, site_check_id))
      {:error, changeset} ->
        site_check = load_site_check(conn, site_check_id)
        render(conn, "index.html", site_check: site_check, steps: site_check.steps, changeset: changeset)
    end
  end

  def update(conn, %{"site_check_id" => site_check_id, "id" => id, "step" => step_params}) do
    step = load_step(conn, site_check_id, id)
    changeset = Step.changeset(step, step_params)

    case Repo.update(changeset) do
      {:ok, step} ->
        conn
        |> put_flash(:info, "Step updated successfully.")
        |> redirect(to: site_check_step_path(conn, :index, step.site_check_id))
      {:error, changeset} ->
        # TODO: BREAKS ATM
        render(conn, "index.html", step: step, changeset: changeset)
    end
  end

  def delete(conn, %{"site_check_id" => site_check_id, "id" => id}) do
    step = load_step(conn, site_check_id, id)
    Repo.delete!(step)

    conn
    |> put_flash(:info, "Step deleted successfully.")
    |> redirect(to: site_check_step_path(conn, :index, step.site_check_id))
  end

  defp new_changeset do
    SiteChecker.Step.changeset(%SiteChecker.Step{})
  end

  defp load_step(conn, site_check_id, id) do
    site_check = load_site_check(conn, site_check_id)
    Repo.get_by!(Step, id: id, site_check_id: site_check.id)
  end

  defp load_site_check(conn, id) do
    account = current_account(conn)
    Repo.get_by!(SiteCheck, id: id, account_id: account.id)
    |> Repo.preload([steps: (from s in Step, order_by: s.id)])
  end
end
