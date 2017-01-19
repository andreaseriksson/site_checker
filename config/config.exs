# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :site_checker,
  ecto_repos: [SiteChecker.Repo]

# Configures the endpoint
config :site_checker, SiteChecker.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ECthfCuV/op01Fq3cuFPLer4TSXK0WqoAIGLpZM16HF0gvo0F6L6500ZVUx1Czaj",
  render_errors: [view: SiteChecker.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SiteChecker.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "SiteChecker",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "fhdskfhgsfjghfdjkhgkfldgjkdf",
  serializer: SiteChecker.GuardianSerializer
