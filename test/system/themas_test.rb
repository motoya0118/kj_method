require "application_system_test_case"

class ThemasTest < ApplicationSystemTestCase
  setup do
    @thema = themas(:one)
  end

  test "visiting the index" do
    visit themas_url
    assert_selector "h1", text: "Themas"
  end

  test "creating a Thema" do
    visit themas_url
    click_on "New Thema"

    check "Lock" if @thema.lock
    fill_in "Name", with: @thema.name
    fill_in "Purpose", with: @thema.purpose
    click_on "Create Thema"

    assert_text "Thema was successfully created"
    click_on "Back"
  end

  test "updating a Thema" do
    visit themas_url
    click_on "Edit", match: :first

    check "Lock" if @thema.lock
    fill_in "Name", with: @thema.name
    fill_in "Purpose", with: @thema.purpose
    click_on "Update Thema"

    assert_text "Thema was successfully updated"
    click_on "Back"
  end

  test "destroying a Thema" do
    visit themas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Thema was successfully destroyed"
  end
end
