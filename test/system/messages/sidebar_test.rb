require "application_system_test_case"

class MessagesSidebarTest < ApplicationSystemTestCase
  setup do
    @user = users(:keith)
    login_as @user
  end

  test "clicking conversations in the left side updates the right column, the path, and back button works as expected" do
    assistant = @user.assistants.ordered.first

    visit root_url

    assert_current_path new_assistant_message_path(assistant)
    assert_selected_assistant assistant

    click_text conversations(:greeting).title
    assert_current_path conversation_messages_path(conversations(:greeting))
    assert_selected_assistant conversations(:greeting).assistant
    assert_first_message conversations(:greeting).messages.ordered.first

    click_text conversations(:javascript).title
    assert_current_path conversation_messages_path(conversations(:javascript))
    assert_selected_assistant conversations(:javascript).assistant
    assert_first_message conversations(:javascript).messages.ordered.first

    click_text conversations(:ruby_version).title
    assert_current_path conversation_messages_path(conversations(:ruby_version))
    assert_selected_assistant conversations(:ruby_version).assistant
    assert_first_message conversations(:ruby_version).messages.ordered.first

    # TODO: These two cases should be working but this test sporadically fails. I suspect that there is actually
    # bugginess in the back-state management of turbo but we need to dig in and figure out why.
    #
    # page.go_back
    # sleep 2
    # assert_current_path conversation_messages_path(conversations(:javascript))
    # assert_selected_assistant conversations(:javascript).assistant
    # assert_first_message conversations(:javascript).messages.ordered.first

    # page.go_back
    # sleep 2
    # assert_current_path conversation_messages_path(conversations(:greeting))
    # assert_selected_assistant conversations(:greeting).assistant
    # assert_first_message conversations(:greeting).messages.ordered.first

    # TODO: There is a bug with the latest turbo where the final back doesn't properly load from cache.
    #
    # page.go_back
    # sleep 2
    # assert_current_path new_assistant_message_path(assistant)
    # assert_selected_assistant assistant
  end

  test "sidebar close handle shows proper tooltip and hides/shows column when clicked" do
    assert_visible "#left-column"

    assert_visible "#left-handle"
    assert_shows_tooltip "#left-handle", "Close sidebar"
    assert_hidden "#right-handle"

    click_element "#handle"

    assert_hidden "#left-column"

    assert_visible "#right-handle"
    assert_shows_tooltip "#right-handle", "Open sidebar"
    assert_hidden "#left-handle"

    click_element "#handle"

    assert_visible "#left-column"

    assert_visible "#left-handle"
    assert_shows_tooltip "#left-handle", "Close sidebar"
    assert_hidden "#right-handle"
  end

  test "meta+. opens and closes sidebar" do
    assert_visible "#left-column"

    assert_visible "#left-handle"
    assert_hidden "#right-handle"

    send_keys "meta+."

    assert_hidden "#left-column"

    assert_visible "#right-handle"
    assert_hidden "#left-handle"

    send_keys "meta+."

    assert_visible "#left-column"

    assert_visible "#left-handle"
    assert_hidden "#right-handle"
  end

  test "meta+shift+s opens and closes sidebar" do
    assert_visible "#left-column"

    assert_visible "#left-handle"
    assert_hidden "#right-handle"

    send_keys "meta+shift+s"

    assert_hidden "#left-column"

    assert_visible "#right-handle"
    assert_hidden "#left-handle"

    send_keys "meta+shift+s"

    assert_visible "#left-column"

    assert_visible "#left-handle"
    assert_hidden "#right-handle"
  end

  test "clicking the assistant name in the sidebar starts a new conversation" do
    conversation_path = conversation_messages_path(conversations(:greeting))
    visit conversation_path
    assert_current_path conversation_path

    assistant1 = @user.assistants.ordered.first
    click_text assistant1.name, match: :first
    assert_current_path new_assistant_message_path(assistant1)

    assistant2 = @user.assistants.ordered.second
    second_assistant_container = all("#assistants [data-role='assistant']", visible: :false)[1]
    second_assistant_container.hover
    pencil_on_second_assistant = all("#assistants a[data-role='pencil']", visible: :false)[1]
    assert_shows_tooltip pencil_on_second_assistant, "New"
    click_element pencil_on_second_assistant
    assert_current_path new_assistant_message_path(assistant2)
  end

  private

  def assert_selected_assistant(assistant)
    assert_selector "#assistants .relationship", text: assistant.name
  end

  def assert_first_message(message)
    assert_selector "#messages > :first-child [data-role='content-text']", text: message.content_text
  end
end
