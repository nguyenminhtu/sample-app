require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @basic_title = "SampleApp |"
  end

  test "should get root" do
    get root_path
    assert_response :success
    assert_select "title", "#{@basic_title} HomePage"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "#{@basic_title} HelpPage"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "#{@basic_title} AboutPage"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "#{@basic_title} ContactPage"
  end
end
