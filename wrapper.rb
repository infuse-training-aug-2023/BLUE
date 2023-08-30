require 'selenium-webdriver'

class Driver
  def initialize(driver_path, browser, timeout)
    Selenium::WebDriver::Chrome::Service.driver_path = driver_path
    @driver = Selenium::WebDriver.for browser
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = timeout
  end

  def get(url)
    begin
      @driver.get(url)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def current_url
    begin
      @driver.current_url
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def switch_to_frame(frame)
    begin
      @driver.switch_to.frame(frame)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def execute_script(script, *args)
    begin
      @driver.execute_script(script, *args)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
  
  def switch_to_default_content
    begin
      @driver.switch_to.default_content
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def quit
    begin
      @driver.quit
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end

class MouseActions
  def initialize(driver)
    @driver = driver
  end

  def click(element)
    begin
      element.click
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def move_to(element, x, y)
    begin
      if x.nil? || y.nil?
        @driver.action.move_to(element).perform
      else
        @driver.action.move_to(element, x, y).perform
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end

class KeyboardActions
  def initialize(driver)
    @driver = driver
  end

  def send_keys(element, value)
    begin
      element.send_keys(value)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end

class ElementActions
  def initialize(driver)
    @driver = driver
  end

  def find_element(selector, element)
    begin
      @driver.find_element(selector, element)
    rescue StandardError => e
      raise e
    end
  end

  def find_elements(selector, element)
    begin
      @driver.find_elements(selector, element)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def text(element)
    begin
      element.text
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end

class Wrapper
  def initialize(driver_path, browser = :chrome, timeout = 15)
    Selenium::WebDriver::Chrome::Service.driver_path = driver_path
    @driver = Selenium::WebDriver.for browser
    @driver.manage.window.maximize
    @driver.manage.timeouts.implicit_wait = timeout
    @mouse = MouseActions.new(@driver)
    @keyboard = KeyboardActions.new(@driver)
    @element = ElementActions.new(@driver)
  end

  def get(url)
    begin
      @driver.get(url)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def current_url
    begin
      @driver.current_url
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def switch_to_frame(frame)
    begin
      @driver.switch_to.frame(frame)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def execute_script(script, *args)
    begin
      @driver.execute_script(script, *args)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def switch_to_default_content
    begin
      @driver.switch_to.default_content
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def quit
    begin
      @driver.quit
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def click(element)
    begin
      @mouse.click(element)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def move_to(element, x = nil, y = nil)
    begin
      @mouse.move_to(element, x, y)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def send_keys(element, value)
    begin
      @keyboard.send_keys(element, value)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end

  def find_element(selector, element)
    begin
      @element.find_element(selector, element)
    rescue StandardError => e
      raise e
    end
  end

  def find_elements(selector, element)
    begin
      @element.find_elements(selector, element)
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end