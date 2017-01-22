defmodule SiteChecker.SiteCheck do
  use SiteChecker.Web, :model

  schema "site_checks" do
    field :name, :string
    field :scheduled, :boolean, default: false
    belongs_to :account, SiteChecker.Account
    has_many :steps, SiteChecker.Step
    has_many :expectations, SiteChecker.Expectation

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :scheduled])
    |> validate_required([:name, :scheduled])
  end
end
