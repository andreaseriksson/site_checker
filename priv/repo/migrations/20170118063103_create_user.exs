defmodule SiteChecker.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :account_id, references(:accounts, on_delete: :delete_all)
      add :password_hash, :string

      add :reset_password_token, :string
      add :reset_password_sent_at, :naive_datetime

      timestamps()
    end

  end
end
