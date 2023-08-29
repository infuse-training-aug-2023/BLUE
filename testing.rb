require 'test/unit'
require 'selenium-webdriver'
require_relative 'wrapper'

class TestWrapper < Test::Unit::TestCase
  def setup
    @driver_path = 'C:\Users\madhura.patil\Desktop\Git training\selenium\drivers\chromedriver.exe'
    @browser = :chrome
    @timeout = 15
    @wrapper = Wrapper.new(@driver_path, @browser, @timeout)
    @wrapper.get('https://practise.usemango.co.uk') 
  end

  def teardown
    @wrapper.quit
  end

  def test_find_element
    result = @wrapper.find_element(:css, '#root > nav > a')
    assert_equal('useMango DemoWebsite', result.text)
  end
  


  def test_move_to
    
    products_element = @wrapper.find_element(:id, 'products')

    initial_color = products_element.css_value('color')
  
    expected_initial_color = 'rgba(255, 255, 255, 0.5)'
  
    @wrapper.move_to(products_element)
  
    hovered_color = products_element.css_value('color')
  
    expected_hovered_color = 'rgba(255, 255, 255, 0.75)'  
  
    assert_equal(expected_initial_color, initial_color, "Initial color is not as expected")
    assert_not_equal(initial_color, hovered_color, "Color did not change after hovering")
    assert_equal(expected_hovered_color, hovered_color, "Color is not as expected after hovering")
  
    @wrapper.move_to(products_element, 10, 20)
  
    moved_color = products_element.css_value('color')
  
    expected_moved_color = 'rgba(255, 255, 255, 0.5)'  
  
    assert_equal(expected_moved_color, moved_color, "Color is not as expected after moving with x and y values")
    assert_not_equal(expected_hovered_color, moved_color, "Expected Hovered Color and moved color should not be the same")
    assert_equal(initial_color, moved_color, "Initial color and moved color should be the same")

  end
  
  def test_find_elements
      products = @wrapper.find_element(:id, 'products')
      @wrapper.click(products)
      results = @wrapper.find_elements(:css, '#root > div > div > div:nth-child(2) > div:nth-child(2) > select')

      puts results[0].text
  
      assert_equal(1, results.length, 'Expected only one result element')
      assert_equal("All\nLaptops\nPhones\nHeadphones", results[0].text, 'Text does not match expected value')

  end
   

  def test_click
    login_link = @wrapper.find_element(:xpath, '//*[@id="navbarNavAltMarkup"]/div[2]/a[1]')
    @wrapper.click(login_link)
    assert_equal('https://practise.usemango.co.uk/login', @wrapper.current_url)
  end

  def test_send_keys_to_input_field
    login_link = @wrapper.find_element(:xpath, '//*[@id="navbarNavAltMarkup"]/div[2]/a[1]')
    @wrapper.click(login_link)
    username_input = @wrapper.find_element(:id, 'exampleInputEmail1')
    username_input.send_keys('testuser')
    assert_equal('testuser', username_input.attribute('value'))
    password_input = @wrapper.find_element(:id, 'exampleInputPassword1')
    password_input.send_keys('testuser')
    assert_equal('testuser', password_input.attribute('value'))
    
  end

  def test_find_element
    login_link = @wrapper.find_element(:xpath, '//*[@id="navbarNavAltMarkup"]/div[2]/a[1]')
    @wrapper.click(login_link)
    some_element = @wrapper.find_element(:id, 'exampleInputPassword1')
    assert_not_nil(some_element)

  end

  def test_get
    assert_equal('https://practise.usemango.co.uk/', @wrapper.current_url, 'Navigation failed')
  end
  
  def test_current_url_returns_correct_url
    assert_equal('https://practise.usemango.co.uk/', @wrapper.current_url)
  end


end