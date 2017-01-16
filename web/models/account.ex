defmodule SiteChecker.Account do
  use SiteChecker.Web, :model

  schema "accounts" do
    field :name, :string
    field :inactivated_at, Ecto.DateTime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :inactivated_at])
    |> validate_required([:name, :inactivated_at])
  end
end
