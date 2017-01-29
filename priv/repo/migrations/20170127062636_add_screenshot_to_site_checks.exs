defmodule SiteChecker.Repo.Migrations.AddScreenshotToSiteChecks do
  use Ecto.Migration

  def change do
    alter table(:site_checks) do
      add :screenshot, :string
    end
  end
end
