defmodule SiteChecker.Repo.Migrations.CreateSiteCheck do
  use Ecto.Migration

  def change do
    create table(:site_checks) do
      add :name, :string
      add :scheduled, :boolean, default: false, null: false
      add :account_id, references(:accounts, on_delete: :delete_all)

      timestamps()
    end
    create index(:site_checks, [:account_id])

  end
end
