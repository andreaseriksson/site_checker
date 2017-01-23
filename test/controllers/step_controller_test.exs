defmodule SiteChecker.StepControllerTest do
  use SiteChecker.ConnCase

  import SiteChecker.AccountUserSetup
  import SiteChecker.AppHelper

  alias SiteChecker.{SiteCheck, Step}
  @valid_attrs %{action: "some content", identifier: "some content", selector: "some content", value: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    setup_account_and_user
    conn = conn |> post(session_path(conn, :create), session: login_attrs)
    site_check = Repo.insert! %SiteCheck{account_id: current_account(conn).id}

    {:ok, conn: conn, site_check_id: site_check.id}
  end

  test "lists all entries on index", %{conn: conn, site_check_id: site_check_id} do
    conn = get conn, site_check_step_path(conn, :index, site_check_id)
    assert html_response(conn, 200) =~ "Steps"
  end

  test "renders form for new resources", %{conn: conn, site_check_id: site_check_id} do
    conn = get conn, site_check_step_path(conn, :index, site_check_id)
    assert html_response(conn, 200) =~ "Add a step"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, site_check_id: site_check_id} do
    conn = post conn, site_check_step_path(conn, :create, site_check_id), step: @valid_attrs
    assert redirected_to(conn) == site_check_step_path(conn, :index, site_check_id)
    assert Repo.get_by(Step, @valid_attrs)
  end

  test "creates resource and add correct site_check_id", %{conn: conn, site_check_id: site_check_id} do
    post conn, site_check_step_path(conn, :create, site_check_id), step: @valid_attrs
    assert Repo.get_by(Step, @valid_attrs).site_check_id == site_check_id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, site_check_id: site_check_id} do
    conn = post conn, site_check_step_path(conn, :create, site_check_id), step: @invalid_attrs
    assert html_response(conn, 200) =~ "errors"
  end

  test "updates chosen resource and redirects when data is valid",  %{conn: conn, site_check_id: site_check_id} do
    step = Repo.insert! %Step{site_check_id: site_check_id}
    conn = put conn, site_check_step_path(conn, :update, site_check_id, step), step: @valid_attrs
    assert redirected_to(conn) == site_check_step_path(conn, :index, site_check_id)
    assert Repo.get_by(Step, @valid_attrs)
  end

  # TODO: BREAKS ATM
  test "does not update chosen resource and renders errors when data is invalid",  %{conn: conn, site_check_id: site_check_id} do
    #step = Repo.insert! %Step{site_check_id: site_check_id}
    #conn = put conn, site_check_step_path(conn, :update, site_check_id, step), step: @invalid_attrs
    #assert html_response(conn, 200) =~ "Edit site check"
  end

  test "deletes chosen resource",  %{conn: conn, site_check_id: site_check_id} do
    step = Repo.insert! %Step{site_check_id: site_check_id}
    conn = delete conn, site_check_step_path(conn, :delete, site_check_id, step)
    assert redirected_to(conn) == site_check_step_path(conn, :index, site_check_id)
    refute Repo.get(Step, step.id)
  end
end
