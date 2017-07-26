require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template "static_pages/home"
    get contact_path
    assert_select "title", full_title("ContactPage")
  end
end
