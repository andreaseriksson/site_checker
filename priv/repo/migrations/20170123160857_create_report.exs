defmodule SiteChecker.Repo.Migrations.CreateReport do
  use Ecto.Migration

  def change do
    create table(:reports) do
      add :status, :string
      add :data, :map
      add :site_check_id, references(:site_checks, on_delete: :delete_all)

      timestamps()
    end
    create index(:reports, [:site_check_id])

  end
end
