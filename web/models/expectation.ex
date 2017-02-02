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

  def match_options do
    %{
      "Has element?" => "HAS_ELEMENT",
      "Element visible?" => "ELEMENT_VISIBLE",
      "Element has text?" => "ELEMENT_HAS_TEXT"
    }
  end

  def readable(expectation) do
    case [expectation.identify_type, expectation.identify_value, expectation.match_content, expectation.match_type] do
      [_, _, _, "ELEMENT_VISIBLE"] ->
        "Page should have element "
      [_, _, _, "ELEMENT_HAS_TEXT"] ->
        "Page should have text.."
      [_, _, _, "HAS_ELEMENT"] ->
        "Page should have element `#{expectation.identify_value}`"
    end
    #match_type = Enum.find(match_options, fn {key, val} -> val == expectation.match_type end) |> elem(0)
    #identify_type = Enum.find(SiteChecker.Step.identifier_options, fn {key, val} -> val == expectation.identify_type end) |> elem(0)

    "Page should have element `#{expectation.identify_value}` with content `#{expectation.match_content}`"
  end
end
