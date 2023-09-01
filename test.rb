require 'test/unit'
require 'selenium-webdriver'
require_relative 'wrapper'

class TestWrapper < Test::Unit::TestCase
  def setup
    @driver_path = ENV['CHROMEDRIVER'] || 'C:\Users\JasonGonsalves\Documents\Infuse\BLUE\chromedriver-win64\chromedriver.exe'
    @browser = :chrome
    @timeout = 15
    @headless = true
    @dummy_website_url = 'https://practise.usemango.co.uk'
    @width = 1920
    @height = 1080
    @wrapper = Wrapper.new(@driver_path, @browser, @timeout, @headless, @width, @height)
    @wrapper.get(@dummy_website_url)
  end

  
  def teardown
    @wrapper.quit
  end


  def test_mouse_actions_instance_created
    mouse_actions = MouseActions.new(@driver) 
    assert_instance_of(MouseActions, mouse_actions)
  end

  
  def test_keyboard_actions_instance_created
    keyboard_actions = KeyboardActions.new(@driver) 
    assert_instance_of(KeyboardActions, keyboard_actions)
  end

  
  def test_element_actions_instance_created
    element_actions = ElementActions.new(@driver)
    assert_instance_of(ElementActions, element_actions)
  end


  def test_text
    @element_actions = ElementActions.new(@driver)
    element=@wrapper.find_element(:css, '#root > nav > a')
    result = @element_actions.text(element)
    assert_equal('useMango DemoWebsite', result)
  end


  def test_find_element
    result = @wrapper.find_element(:css, '#root > nav > a')
    assert_not_nil(result)
    assert_equal('useMango DemoWebsite', result.text)
  end

  
  def test_element_not_present
    assert_raise(Selenium::WebDriver::Error::NoSuchElementError) do
      @wrapper.find_element(:id, 'id1234')
    end
  end


  def test_empty_selector
    assert_raise(Selenium::WebDriver::Error::InvalidSelectorError) do
      element = @wrapper.find_element(:id, nil)
    end
  end
 

  def no_such_element_present
    assert_raise(Selenium::WebDriver::Error::InvalidArgumentError) do
      element = @wrapper.find_element(:id, 'mobiles')
    end
    assert_raise(Selenium::WebDriver::Error::InvalidArgumentError) do
      element = @wrapper.find_element(:class, 'dvd')
    end
  end
  

  def test_find_elements
    products = @wrapper.find_element(:id, 'products')
    @wrapper.click(products)
    results = @wrapper.find_elements(:css, '#root > div > div > div:nth-child(2) > div:nth-child(2) > select')

    assert_not_nil(results, 'Results should not be nil')
    assert_equal(1, results.length, 'Expected only one result element')
    assert_equal("All\nLaptops\nPhones\nHeadphones", results[0].text, 'Text does not match expected value')
  end


  def test_click
    login_link = @wrapper.find_element(:xpath, '//*[@id="navbarNavAltMarkup"]/div[2]/a[1]')
    assert_not_nil(login_link, 'Login link not found')
    @wrapper.click(login_link)
    assert_equal('https://practise.usemango.co.uk/login', @wrapper.current_url)
  end


  def test_send_keys_to_input_field
    login_link = @wrapper.find_element(:xpath, '//*[@id="navbarNavAltMarkup"]/div[2]/a[1]')
    assert_not_nil(login_link, 'Login link not found')

    @wrapper.click(login_link)
    username_input = @wrapper.find_element(:id, 'exampleInputEmail1')
    assert_not_nil(username_input, 'Username input field not found')

    @wrapper.send_keys(username_input, 'testuser')
    assert_equal('testuser', username_input.attribute('value'))
    password_input = @wrapper.find_element(:id, 'exampleInputPassword1')
    assert_not_nil(password_input, 'Password input field not found')
    @wrapper.send_keys(password_input, 'testuser')
    assert_equal('testuser', password_input.attribute('value'))
  end


  def test_find_nonexistent_element
    nonexistent_element = @wrapper.find_elements(:id, 'nonexistent-element')
    assert_empty(nonexistent_element, 'Nonexistent element should not be found')
  end
  

  def test_find_nonexistent_elements
    nonexistent_elements = @wrapper.find_elements(:class, 'nonexistent-class')
    assert_empty(nonexistent_elements, 'No nonexistent elements should be found')
  end


  def test_invalid_css_selector
    assert_raise Selenium::WebDriver::Error::NoSuchElementError do
      invalid_element = @wrapper.find_element(:css, 'invalid-selector')
    end
  end
  
  
  def test_navigation_to_different_pages
    @wrapper.get(@dummy_website_url)
    expected_url = URI.parse(@dummy_website_url)
    actual_url = URI.parse(@wrapper.current_url)
    assert_equal(expected_url, actual_url, "Navigation failed. Expected URL: #{expected_url}, Actual URL: #{actual_url}")
    
    other_url = 'https://www.google.com/'
    @wrapper.get(other_url)
    expected_other_url = URI.parse(other_url)
    actual_other_url = URI.parse(@wrapper.current_url)
    assert_equal(expected_other_url, actual_other_url, "Navigation failed. Expected URL: #{expected_other_url}, Actual URL: #{actual_other_url}")
  end
  
  
  def test_keyboard_actions_on_readonly_field
    @keyboard_actions = KeyboardActions.new(@driver)
    field = @wrapper.find_element(:css, '#root > nav > a')
    input_field = @wrapper.find_element(:css, '#root > nav > a')
    input_text = "Hello, World!"
    input_field.send_keys(input_text)
    actual_value = input_field.attribute('value')
    assert_nil(actual_value)
  end

    
  def test_execute_script
    script = "return 'Hello, World!';"
    result = @wrapper.execute_script(script)
    assert_equal('Hello, World!', result, 'Script execution result does not match expected value')
  end
end