defmodule SiteChecker.Check do
  use Hound.Helpers
  import Ecto.Query
  alias SiteChecker.{Repo, SiteCheck, Step, Expectation, ResultBuilder}
  # Start phantomjs --wd

  def visit_url_and_screenshot(site_check) do
    # alias SiteChecker.{ SiteCheck, Check, Repo }
    # r Check
    # site_check = SiteCheck |> Repo.get(6) |> Repo.preload(:account) |> Repo.preload(:steps) |> Repo.preload(:expectations)
    # site_check |> Check.visit_url_and_screenshot

    image_name = site_check.name
                 |> String.downcase
                 |> String.replace(~r/[^a-z]/, "-")

    image_name = "#{site_check.id}-#{image_name}.png"

    {_, errors} = ResultBuilder.start_link

    Hound.start_session
    navigate_to site_check.url
    screeshot = take_screenshot(image_name)

    # TODO: Give it a name and upload to S3
    case screeshot do
      image_name ->
        params = %{
          "screenshot" => %Plug.Upload{
            content_type: "image/png",
            filename: image_name,
            path: Path.expand("./#{image_name}")
          }
        }

        SiteChecker.SiteCheck.screenshot_changeset(site_check, params)
        |> Repo.update

        File.rm(image_name)
      _ ->
        IO.inspect "Handle error"
    end

    Hound.end_session
    {:ok, errors}
  end

  def start(site_check) do
    IO.puts "starting"
    Hound.start_session

    {_, results} = ResultBuilder.start_link

    navigate_to site_check.url

    for step <- site_check.steps do
      case step.action do
        "VISIT_URL" ->
          visit_url(step, results)
        "FILL_IN_FIELD" ->
          fill_in_field(step, results)
        "CLICK" ->
          click_element(step, results)
        _ ->
         nil
         # Something is really wrong
      end
    end

    for expectation <- site_check.expectations do
      case expectation.match_type do
        "HAS_VISIBLE" ->
          has_element(expectation, results)
        "ELEMENT_VISIBLE" ->
          element_visible(expectation, results)
        "ELEMENT_HAS_TEXT" ->
          element_has_text(expectation, results)
        _ ->
         nil
         # Something is really wrong
      end
    end

    Hound.end_session
    ResultBuilder.result(results)
  end

  defp visit_url(step, results) do
    result = try do
      navigate_to step.value
      :ok
    rescue
      _ -> :error
    end
    attach_result(results, {:step, step, result})
  end

  defp fill_in_field(step, results) do
    result = try do
      identifier = String.downcase(step.identifier) |> String.to_atom()
		  element = find_element(identifier, step.selector)
      fill_field(element, step.value)
      :ok
    rescue
      _ -> :error
    end
    attach_result(results, {:step, step, result})
  end

  defp click_element(step, results) do
    result = try do
      identifier = String.downcase(step.identifier) |> String.to_atom()
		  element = find_element(identifier, step.selector)
      click element
      :ok
    rescue
      _ -> :error
    end
    attach_result(results, {:step, step, result})
  end

  defp has_element(expectation, results) do
    # IO.inspect element?(:css, '.info-box-text')
    # IO.inspect element?(:class, "block")
    # IO.inspect element?(:id, "foo")
    result = try do
      identifier = String.downcase(expectation.identify_type) |> String.to_atom()
		  element = find_element(identifier, expectation.identify_value)
      element_displayed?(element)
      :ok
    rescue
      _ -> :error
    end
    attach_result(results, {:expectation, expectation, result})
  end

  defp element_visible(expectation, results) do
    # IO.inspect find_element(:css, ".info-box-text")
    # IO.inspect element?(:css, '.info-box-text')
    # IO.inspect element?(:class, "block")
    # IO.inspect element?(:id, "foo")
    # IO.inspect fetch_errors()
    # IO.inspect element_displayed?(element)
    # IO.inspect visible_in_page?(~r/Awesome first flow/)
    result = try do
      identifier = String.downcase(expectation.identify_type) |> String.to_atom()
		  element = find_element(identifier, expectation.identify_value)
      element_displayed?(element)
      :ok
    rescue
      _ -> :error
    end
    attach_result(results, {:expectation, expectation, result})
  end

  defp element_has_text(expectation, results) do
    # element2 = find_element(:css, ".content-header h1")
    #	IO.inspect inner_text(element2)
    # IO.inspect visible_in_page?(~r/Awesome first flow/)
    result = try do
      identifier = String.downcase(expectation.identify_type) |> String.to_atom()
		  element = find_element(identifier, expectation.identify_value)
      element_displayed?(element)
      :ok
    rescue
      _ -> :error
    end
    attach_result(results, {:expectation, expectation, result})
  end

  defp attach_result(results, result) do
    # IO.inspect fetch_errors()

    # Format an error
    #%ScrapeTest.Report{
    #  event: "Some string description",
    #  success: "false",
    #  message: "",
    #  text: "",
    #  screenshot: ""
    #}
    case result do
      {_, _, :error} ->
        take_screenshot()
      _ -> nil # Do nothing
    end

    ResultBuilder.add(results, result)
  end
end
