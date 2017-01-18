defmodule SiteChecker.Email do
  use Bamboo.Phoenix, view: SiteChecker.EmailView

  def welcome_email(user) do
    base_email
    |> to(user.email)
    |> subject("Welcome!!!")
    |> render(:welcome_email, user: user)
  end

  defp base_email do
    new_email
    |> from("myapp@example.com")
    |> put_html_layout({SiteChecker.LayoutView, "email.html"})
    # |> put_text_layout({MyApp.LayoutView, "text.html"})
  end
end
