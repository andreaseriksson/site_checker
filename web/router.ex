defmodule SiteChecker.Router do
  use SiteChecker.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", SiteChecker do
    pipe_through [:browser, :browser_session] # Use the default browser stack

    get "/", PageController, :index
    get "/signup", AccountController, :new
    resources "/accounts", AccountController, only: [:create]
    get "/signin", SessionController, :new
    post "/session", SessionController, :create
    delete "/session", SessionController, :destroy
  end

  # Other scopes may use custom stacks.
  # scope "/api", SiteChecker do
  #   pipe_through :api
  # end
end
