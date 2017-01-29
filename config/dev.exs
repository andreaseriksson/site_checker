use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :site_checker, SiteChecker.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../", __DIR__)]]


# Watch static and templates for browser reloading.
config :site_checker, SiteChecker.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Import the config/dev.secret.exs
# which should be versioned separately.
import_config "dev.secret.exs"

# Configure your database
config :site_checker, SiteChecker.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "site_checker_dev",
  hostname: "localhost",
  pool_size: 10

config :site_checker, SiteChecker.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "localhost",
  username: "",
  password: "",
  port: 1025,
  # tls: :if_available, # can be `:always` or `:never`
  # ssl: false, # can be `true`
  retries: 1

config :hound, driver: "phantomjs"
