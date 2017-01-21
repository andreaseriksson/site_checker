defmodule SiteChecker.Expectation do
  use SiteChecker.Web, :model

  schema "expectations" do
    field :identify_type, :string
    field :identify_value, :string
    field :match_content, :string
    field :match_type, :string
    belongs_to :site_check, SiteChecker.SiteCheck

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:identify_type, :identify_value, :match_content, :match_type])
    |> validate_required([:identify_type, :identify_value, :match_content, :match_type])
  end
end
