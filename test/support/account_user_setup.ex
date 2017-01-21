defmodule SiteChecker.AccountUserSetup do
  alias SiteChecker.{Repo, Account, User}

  @login_attrs %{email: "some_email@example.com", password: "abcdef"}

  @account %{ name: "some content",
              users: [%{
                name: "Some name",
                email: "some_email@example.com",
                password: "abcdef",
                password_confirmation: "abcdef"
              }]
            }

  def setup_account_and_user do
    account = Account.changeset(%Account{}, @account) |> Repo.insert!
    user = account.users |> List.first
    {account, user}
  end

  def login_attrs do
    @login_attrs
  end
end
