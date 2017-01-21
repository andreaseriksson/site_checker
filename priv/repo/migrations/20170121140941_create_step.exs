defmodule SiteChecker.Repo.Migrations.CreateStep do
  use Ecto.Migration

  def change do
    create table(:steps) do
      add :action, :string
      add :identifier, :string
      add :selector, :string
      add :value, :string
      add :site_check_id, references(:site_checks, on_delete: :delete_all)

      timestamps()
    end
    create index(:steps, [:site_check_id])

  end
end
