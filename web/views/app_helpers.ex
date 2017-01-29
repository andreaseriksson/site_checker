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

  def cloudinary_url(attribute, model, options \\ %{}) do
    if attribute do
      base_url = "https://res.cloudinary.com/#{Application.get_env(:site_checker, :cloudinary_cloud_name)}/image/fetch"
      options = "c_fill,g_north,h_300,w_300" # TODO: Fix later
      fetch_url = SiteChecker.Screenshot.url({attribute, model}, signed: true)
      "#{base_url}/#{options}/#{fetch_url}"
    end
  end
end
