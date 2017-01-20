defmodule SiteChecker.AccountController do
  use SiteChecker.Web, :controller

  alias SiteChecker.{Account, User, Email, Mailer}

  plug :put_layout, "session.html"

  def new(conn, _params) do
    changeset = Account.changeset(%Account{users: [%User{}]})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"account" => account_params}) do
    changeset = Account.changeset(%Account{}, account_params)

    case Repo.insert(changeset) do
      {:ok, account} ->
        user = account.users |> List.first

        user
        |> Email.welcome_email
        |> Mailer.deliver_later

        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: dashboard_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
