defmodule SiteChecker.SiteCheck do
  use SiteChecker.Web, :model
  use Arc.Ecto.Schema

  schema "site_checks" do
    field :name, :string
    field :url, :string
    field :scheduled, :boolean, default: false
    field :screenshot, SiteChecker.Screenshot.Type
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
    |> cast(params, [:name, :url, :scheduled])
    |> validate_required([:name, :url, :scheduled])
    |> validate_url(:url, message: "URL is not a valid URL!")
  end

  @doc """
  Only just for uploading the screenshot
  """
  def screenshot_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> cast_attachments(params, [:screenshot])
    |> validate_required([:screenshot])
  end

  def validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect msg}"}]
      end
    end
  end
end
