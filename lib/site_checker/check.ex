defmodule SiteChecker.Check do
  use Hound.Helpers
  import Ecto.Query
  alias SiteChecker.{Repo, SiteCheck, Step, Expectation, PageCheckErrorHandler}
  # Start phantomjs --wd

  def visit_url_and_screenshot(site_check) do
    # alias SiteChecker.{ SiteCheck, Check, Repo }
    # r Check
    # site_check = SiteCheck |> Repo.get(2)
    # site_check |> Check.visit_url_and_screenshot

    image_name = site_check.name
                 |> String.downcase
                 |> String.replace(~r/[^a-z]/, "-")

    image_name = "#{site_check.id}-#{image_name}.png"

    {_, errors} = PageCheckErrorHandler.start_link

    Hound.start_session
    navigate_to site_check.url
    screeshot = take_screenshot(image_name)
    IO.inspect screeshot

    # TODO: Give it a name and upload to S3
    case screeshot do
      image_name ->
        "upload"
        params = %{
          "screenshot" => %Plug.Upload{
            content_type: "image/png",
            filename: image_name,
            path: Path.expand("./#{image_name}")
          }
        }
        changeset = SiteChecker.SiteCheck.screenshot_changeset(site_check, params)
        IO.inspect changeset
        IO.inspect Repo.update(changeset)
        File.rm(image_name)
      _ ->
        IO.inspect "Handle error"
    end

    Hound.end_session
    {:ok, errors}
  end

  def start do
    IO.puts "starting"
    Hound.start_session

    {_, errors} = PageCheckErrorHandler.start_link

    page_test = Repo.get!(PageTest, 2)
                |> Repo.preload([steps: (from s in Step, order_by: s.id) ])
                |> Repo.preload([expectations: (from e in Expectation, order_by: e.id) ])

    for step <- page_test.steps do
      case step.action do
        "VISIT_URL" ->
          visit_url(step, errors)
        "FILL_IN_FIELD" ->
          fill_in_field(step, errors)
        "CLICK" ->
          click_element(step, errors)
        _ ->
         nil
         # Something is really wrong
      end
    end

    for expectation <- page_test.expectations do
      case expectation.match_type do
        "ELEMENT_VISIBLE" ->
          element_visible(expectation, errors)
        _ ->
         nil
         # Something is really wrong
      end
    end
    # take_screenshot()
    # run_steps
    # run_expectations

		# Floki.find(page_source(), "tbody")
    # |> Floki.find("tr")
    # |> Enum.map(fn(tr) -> Floki.find(tr, "td") end)
    # |> IO.inspect
    Hound.end_session()
  end

	def run_steps do
    navigate_to "http://localhost:3000/app"
		find_element(:id, "app_user_email") |> fill_field('andreas@codered.se')
		el = find_element(:id, "app_user_password")
		fill_field(el, 'teddybear')
		submit_element(el)
		navigate_to "http://localhost:3000/app/flows"
	end

	def run_expectations do
		element = find_element(:class, "breadcrumb")
		IO.inspect element_displayed?(element)

		element2 = find_element(:css, ".content-header h1")
		IO.inspect inner_text(element2)

    IO.inspect element?(:class, "smurf")
    IO.inspect visible_in_page?(~r/Awesome first flow/)
	end

  defp visit_url(step, errors) do
    navigate_to step.value
    {:ok, errors}
  end

  defp fill_in_field(step, _errors) do
    identifier = String.downcase(step.identifier) |> String.to_atom()
		element = find_element(identifier, step.selector)
    fill_field(element, step.value)
  end

  defp click_element(step, _errors) do
    identifier = String.downcase(step.identifier) |> String.to_atom()
		element = find_element(identifier, step.selector)
    click element
  end

  defp element_visible(expectation, _errors) do
    identifier = String.downcase(expectation.identify_type) |> String.to_atom()
		element = find_element(identifier, expectation.identify_value)
    # IO.inspect find_element(:css, ".info-box-text")
    # IO.inspect element?(:css, '.info-box-text')
    # IO.inspect element?(:class, "block")
    # IO.inspect element?(:id, "foo")
    # IO.inspect fetch_errors()
    # IO.inspect element_displayed?(element)
    {:ok, element_displayed?(element) }
  end

  defp attach_result(errors, something) do
    # Format an error
    #%ScrapeTest.Report{
    #  event: "Some string description",
    #  success: "false",
    #  message: "",
    #  text: "",
    #  screenshot: ""
    #}
    error = something
    errors |> PageCheckErrorHandler.add error
  end
end
