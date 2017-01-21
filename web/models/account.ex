defmodule SiteChecker.Account do
  use SiteChecker.Web, :model

  schema "accounts" do
    field :name, :string
    field :inactivated_at, Ecto.DateTime
    has_many :users, SiteChecker.User
    has_many :site_checks, SiteChecker.SiteCheck

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :inactivated_at])
    |> cast_assoc(:users)
    |> validate_required([:name])
  end
end
