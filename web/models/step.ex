defmodule SiteChecker.Step do
  use SiteChecker.Web, :model

  schema "steps" do
    field :action, :string
    field :identifier, :string
    field :selector, :string
    field :value, :string
    belongs_to :site_check, SiteChecker.SiteCheck

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:action, :identifier, :selector, :value])
    |> validate_required([:action, :identifier, :selector, :value])
  end
end
