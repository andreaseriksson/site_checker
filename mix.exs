defmodule SiteChecker.Mixfile do
  use Mix.Project

  def project do
    [app: :site_checker,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {SiteChecker, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :comeonin, :bamboo, :bamboo_smtp, :httpoison,
                    :hound, :ex_aws, :arc_ecto
                  ],
     test_coverage: [tool: Coverex.Task]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:bamboo_smtp, "~> 1.2.1"},
     {:credo, "~> 0.5", only: [:dev, :test]},
     {:comeonin, "~> 3.0"},
     {:guardian, "~> 0.14"},
     {:httpoison, "~> 0.10.0"},
     {:floki, "~> 0.11.0"},
     {:hound, "~> 1.0"},
     {:coverex, "~> 1.4.10", only: :test},
     {:arc, "~> 0.6.0"},
     {:arc_ecto, "~> 0.5.0"},

     # If using Amazon S3:
     {:ex_aws, "~> 1.0.0"},
     {:hackney, "1.6.1", override: true},
     # {:httpoison, "~> 0.11.0"},
     {:sweet_xml, "~> 0.5"}
   ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
