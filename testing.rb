require 'test/unit'
require 'selenium-webdriver'
require_relative 'wrapper'

class TestWrapper < Test::Unit::TestCase
  def setup
    @driver_path = 'G:\selenium training\drivers\chromedriver.exe'
    @browser = :chrome
    @timeout = 15
    @wrapper = Wrapper.new(@driver_path, @browser, @timeout)
    @wrapper.get('https://practise.usemango.co.uk') 
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

  
  def test_click
    login_link = @wrapper.find_element(:xpath, '//*[@id="navbarNavAltMarkup"]/div[2]/a[1]')
    @wrapper.click(login_link)
    assert_equal('https://practise.usemango.co.uk/login', @wrapper.current_url)
  end

  def test_send_keys_to_input_field
    @keyboard_actions = KeyboardActions.new(@driver)
    login_link = @wrapper.find_element(:xpath, '//*[@id="navbarNavAltMarkup"]/div[2]/a[1]')
    @wrapper.click(login_link)
    username_input = @wrapper.find_element(:id, 'exampleInputEmail1')
    @keyboard_actions.send_keys(username_input,'testuser')
    assert_equal('testuser', username_input.attribute('value'))
    password_input = @wrapper.find_element(:id, 'exampleInputPassword1')
    @keyboard_actions.send_keys(password_input,'123')
    assert_equal('123', password_input.attribute('value'))
  end


  def test_get
    assert_equal('https://practise.usemango.co.uk/', @wrapper.current_url, 'Navigation failed')
  end
  
  def test_current_url_returns_correct_url
    assert_equal('https://practise.usemango.co.uk/', @wrapper.current_url)
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

  def test_invalid_url
    assert_raise(Selenium::WebDriver::Error::InvalidArgumentError) do
      @wrapper.get('bhjvh')
    end
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
 

  def test_keyboard_actions_on_readonly_field
    @keyboard_actions = KeyboardActions.new(@driver)
    field = @wrapper.find_element(:css, '#root > nav > a')
    input_field = @wrapper.find_element(:css, '#root > nav > a')
    input_text = "Hello, World!"
    input_field.send_keys(input_text)
    actual_value = input_field.attribute('value')
    assert_nil(actual_value)
  end
  
  def test_move_to_with_coordinates
    @mouse_actions = MouseActions.new(@wrapper.instance_variable_get(:@driver))
    element = @wrapper.find_element(:css, '#root > nav > a') 
    x = 80
    y = 200
    result = @mouse_actions.move_to(element, x, y)
    assert_nil(result)
  end

  def test_move_to_without_coordinates
    @mouse_actions = MouseActions.new(@wrapper.instance_variable_get(:@driver))
    element = @wrapper.find_element(:css, '#root > nav > a') 
    assert_nothing_raised do
      @mouse_actions.move_to(element, nil, nil)
    end
  end
  

  def test_find_elements
    
    products = @wrapper.find_element(:id, 'products')
    @wrapper.click(products)
    results = @wrapper.find_elements(:css, '#root > div > div > div:nth-child(2) > div:nth-child(2) > select')

    puts results[0].text
    
    # assert_equal('Home', results[0].text)
    # assert_equal('About Us', results[2].text)
  end

  # def test_quit_method
  #   quit_result = @wrapper.quit
  #   assert_nil(quit_result)
  # end
  

end
