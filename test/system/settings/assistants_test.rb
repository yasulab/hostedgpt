require "application_system_test_case"

class Settings::AssistantsTest < ApplicationSystemTestCase
  setup do
    @assistant = assistants(:samantha)
    login_as @assistant.user
  end

  test "should create assistant" do
    visit new_settings_assistant_url

    fill_in "Name", with: @assistant.name
    fill_in "Description", with: @assistant.description
    fill_in "Instructions", with: @assistant.instructions

    click_on "Save"

    assert_text "Saved"
  end

  test "should update Assistant" do
    visit edit_settings_assistant_url(@assistant)

    fill_in "Name", with: @assistant.name+"-2"
    fill_in "Description", with: @assistant.description+"-2"
    fill_in "Instructions", with: @assistant.instructions+"-2"

    click_on "Save"

    assert_text "Saved"
  end

  test "should destroy Assistant" do
    visit edit_settings_assistant_url(@assistant)
    accept_confirm do
      click_text "Delete", match: :first
    end
    assert_text "Deleted"

    refute Assistant.exists?(id: @assistant.id)
  end

  test "should cancel destroy Assistant" do
    visit edit_settings_assistant_url(@assistant)
    dismiss_confirm do
      click_text "Delete", match: :first
    end
    assert_no_text "Deleted"

    assert @assistant.reload.present?
  end
end
