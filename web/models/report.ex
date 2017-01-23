defmodule SiteChecker.Report do
  use SiteChecker.Web, :model

  schema "reports" do
    field :status, :string
    field :data, :map
    belongs_to :site_check, SiteChecker.SiteCheck

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status, :data])
    |> validate_required([:status, :data])
  end
end
