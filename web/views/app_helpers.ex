defmodule SiteChecker.AppHelper do
  def current_user(conn), do: Guardian.Plug.current_resource(conn)
  def logged_in?(conn), do: Guardian.Plug.authenticated?(conn)

  def current_account(conn) do
    user = current_user(conn)
    if user do
      user = user |> SiteChecker.Repo.preload(:account)
      user.account
    end
  end
end
