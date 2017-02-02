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

  def readable(step) do
    if Enum.find(~w(FILL_IN_FIELD CLICK), fn(action) -> action == step.action end) do
      action = Enum.find(action_options, fn {key, val} -> val == step.action end) |> elem(0)
      identifier = Enum.find(identifier_options, fn {key, val} -> val == step.identifier end) |> elem(0)

      "#{action} identified by #{identifier} #{format_selector_and_value(step)}"
    else
      "Visit URL `#{step.value}`"
    end
  end

  defp format_selector_and_value(step) do
    if step.value do
      "`#{step.selector}` with `#{step.value}`"
    else
      "`#{step.selector}`"
    end
  end
end
