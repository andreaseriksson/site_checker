defmodule SiteChecker.Repo.Migrations.CreateExpectation do
  use Ecto.Migration

  def change do
    create table(:expectations) do
      add :identify_type, :string
      add :identify_value, :string
      add :match_content, :string
      add :match_type, :string
      add :site_check_id, references(:site_checks, on_delete: :delete_all)

      timestamps()
    end
    create index(:expectations, [:site_check_id])

  end
end
