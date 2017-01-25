defmodule SiteChecker.Repo.Migrations.AddUrlToSiteChecks do
  use Ecto.Migration

  def change do
    alter table(:site_checks) do
      add :url, :string
    end
  end
end
