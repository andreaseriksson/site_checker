defmodule SiteChecker.User do
  use SiteChecker.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :reset_password_token, :string
    field :reset_password_sent_at, Ecto.DateTime
    belongs_to :account, SiteChecker.Account

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`. The third argument is a map
  that contains the key `account_registration` that defaults to `true`. If it is true
  it will validate and hash password as well.
  """
  def changeset(model, params \\ %{}, options \\ %{account_registration: true}) do
    changeset =
      model
      |> cast(params, [:name, :email])
      |> validate_required([:name, :email])
      |> validate_format(:email, ~r/@/)
      |> unique_constraint(:email)

    case options[:account_registration] do
      true ->
        changeset
        |> cast(params, [:password])
        |> validate_length(:password, min: 6, max: 100)
        |> validate_confirmation(:password)
        |> put_pass_hash()
      false ->
        changeset
    end
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
