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
    |> validate_required([:action])
  end

  def action_options do
		%{"Visit URL" => "VISIT_URL", "Fill in field" => "FILL_IN_FIELD", "Click element" => "CLICK"}
  end

  def identifier_options do
		%{"Id" => "ID", "Class" => "CLASS", "CSS" => "CSS", "Name" => "NAME"}
  end
end
