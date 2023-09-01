require 'selenium-webdriver'
require_relative 'wrapper'


class Neemans
    @@BASE_URL = 'https://neemans.com'

  def initialize(driver_path, browser = :chrome, timeout = 10, headless = false, width = 1920, height = 1080)
    @wrapper = Wrapper.new(driver_path, browser, timeout, headless, width, height)
  end

  def login(email_value, password_value)
    @wrapper.get(@@BASE_URL + '/account/login?return_url=%2Faccount')
    
    email = @wrapper.find_element(:name, 'customer[email]')
    password = @wrapper.find_element(:name, 'customer[password]')
    login_button = @wrapper.find_element(:css, 'button[type="submit"]')

    if !email_value.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
        puts "Invalid email"
        return
    else
        email.send_keys(email_value)
    end

    if !password_value.match?(/^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$/)
        puts "Invalid password"
        return
    else
        password.send_keys(password_value)
    end

    original_url = @wrapper.current_url

    login_button.click()

    @wrapper.current_url != original_url

    if @wrapper.current_url == @@BASE_URL + '/challenge'
        puts 'Captcha encountered'
        return
    end
  end

  def logout()
    @wrapper.get(@@BASE_URL + '/account/logout')

    original_url = @wrapper.current_url

    @wrapper.current_url != original_url
  end

  def search(query)
    if !query.is_a?(String) || query.empty?
        puts 'Invalid query'
        return
    end

    @wrapper.get(@@BASE_URL + '/search')

    @wrapper.move_to(@wrapper.find_element(:tag_name, 'body'))

    search_input = @wrapper.find_element(:css, 'input.Form__Input.snize-input-style')

    search_input.send_keys(query)

    search_input.send_keys(:enter)

    @wrapper.move_to(@wrapper.find_element(:tag_name, 'body'))

    sleep(2)
  end

  def sort(view_mode, sort_by)
    if !view_mode.is_a?(String) || view_mode.empty?
        puts 'Invalid view mode option'  
        return  
    end

    if !sort_by.is_a?(String) || sort_by.empty?
        puts 'Invalid sort by option'    
        return
    end

    if !@wrapper.find_elements(:class, 'snize-skeleton-card').empty?
      puts "Stuck on skeleton loading"
      return
    end

    if view_mode == 'grid'
        @wrapper.find_element(:css, '.snize-grid-mode-icon').click()
    elsif view_mode == 'list'
        @wrapper.find_element(:css, '.snize-list-mode-icon').click()
    else
        puts 'Invalid view mode'
        return
    end

    dropdown = @wrapper.find_element(:css, '.snize-main-panel-dropdown')

    @wrapper.click(dropdown.find_element(:css, '.snize-main-panel-dropdown-button'))

    options = @wrapper.find_elements(:css, '.snize-main-panel-dropdown-content a')

    case sort_by
    when 'Relevance'
      options[0].click()
    when 'Title: A-Z'
      options[1].click()
    when 'Title: Z-A'
      options[2].click()
    when 'Date: New to Old'
      options[3].click()
    when 'Date: Old to New'
      options[4].click()
    when 'Price: Low to High'
      options[5].click()
    when 'Price: High to Low'
      options[6].click()
    when 'Discount: High to Low'
      options[7].click()
    when 'Rating: Low to High'
      options[8].click()
    when 'Rating: High to Low'
      options[9].click()
    when 'Total reviews: Low to High'
      options[10].click()
    when 'Total reviews: High to Low'
      options[11].click()
    when 'Bestselling'
      options[12].click()
    else
        puts 'Invalid sort by option'
        return
    end
  end

  def add_to_cart(item, colour, size)
    if !item.is_a?(String) || item.empty?
        puts 'Invalid item name'
        return
    end

    if !colour.is_a?(String) || colour.empty?
        puts 'Invalid colour option'
        return
    end

    if !size.is_a?(Integer) || size <= 0
        puts 'Invalid size option'
        return
    end

    item = item.gsub(' ', '-').downcase()

    @wrapper.get(@@BASE_URL + '/products/' + item)
    
    colour_list = @wrapper.find_element(:css, 'ul.ColorSwatchList')
    colour_options = colour_list.find_elements(:css, 'li')

    matching_option = colour_options.find { |option| option.attribute('data-value') == colour }
    if matching_option
        matching_option.click()
    else
        puts "Invalid colour option: #{colour}"
        return
    end

    size_list = @wrapper.find_element(:css, '.SizeSwatchList')
    size_options = size_list.find_elements(:css, 'li')

    matching_size_option = size_options.find do |option|    
        label = option.find_element(:css, 'label')
        size_value = label.attribute('data-value').gsub('UK ', '').to_i
        size_value == size
      end
    
      if matching_size_option
        label = matching_size_option.find_element(:css, 'label')
        label.click()
    
        if label.attribute('class').include?('strikethrough')
          puts "Selected size #{size} is out of stock"
          return
        end
      else
        puts "Invalid size option: #{size}"
        return
    end

    add_to_cart_button = @wrapper.find_element(:css, '.ProductForm__AddToCart')
    add_to_cart_button.click()

    sleep(2)
  end

  def update_cart(item, colour, size, action)
    if !item.is_a?(String) || item.empty?
        puts 'Invalid item name'
        return
    end

    if !colour.is_a?(String) || colour.empty?
        puts 'Invalid colour option'
        return
    end

    if !size.is_a?(Integer) || size <= 0
        puts 'Invalid size option'
        return
    end

    if !action.is_a?(String) || action.empty?
        puts 'Invalid action'
        return
    end

    item = item.upcase()

    @wrapper.get(@@BASE_URL + '/cart')

    cart_items = @wrapper.find_elements(:css, '.CartItem')

    if cart_items.length == 0
        puts 'Cart is empty'
        return
      end

    item_found = false

    cart_items.each do |cart_item|
        title_element = cart_item.find_element(:css, '.CartItem__Title a')
        variant_element = cart_item.find_element(:css, '.CartItem__Variant')
        quantity_element = cart_item.find_elements(:css, '.CartItem__QuantitySelector a')

        if title_element.text == item && variant_element.text.include?(colour) && variant_element.text.include?(size.to_s)

            if action == 'increase'
                increase_button = quantity_element[1]
                increase_button.click()
            elsif action == 'decrease'
                decrease_button = quantity_element[0]
                decrease_button.click()
            else
                puts 'Invalid action'
                return
            end

            item_found = true

            break
        end
    end

    if !item_found
        item = item.split.map(&:capitalize).join(' ')
        puts "Item not found in cart: #{item} - #{colour} - #{size}"
        return 
    end

    sleep(2)
  end

  def remove_from_cart(item, colour, size)
    if !item.is_a?(String) || item.empty?
        puts 'Invalid item name'
        return
    end

    if !colour.is_a?(String) || colour.empty?
        puts 'Invalid colour option'
        return
    end

    if !size.is_a?(Integer) || size <= 0
        puts 'Invalid size option'
        return
    end

    item = item.upcase()

    @wrapper.get(@@BASE_URL + '/cart')

    cart_items = @wrapper.find_elements(:css, '.CartItem')

    if cart_items.length == 0
        puts 'Cart is empty'
        return
      end

    item_found = false

    cart_items.each do |cart_item|
        title_element = cart_item.find_element(:css, '.CartItem__Title a')
        variant_element = cart_item.find_element(:css, '.CartItem__Variant')

        if title_element.text == item && variant_element.text.include?(colour) && variant_element.text.include?(size.to_s)
            remove_button = cart_item.find_element(:css, '.CartItem__Remove')
            remove_button.click()

            item_found = true

            break
        end
    end

    if !item_found
        item = item.split.map(&:capitalize).join(' ')
        puts "Item not found in cart: #{item} - #{colour} - #{size}"
        return 
    end

    sleep(2)
  end

  def get_account_info()
    sleep(2)
    @wrapper.get(@@BASE_URL + '/account')

    description_element = nil

    begin
      description_element = @wrapper.find_element(:class, 'SectionHeader__Description')
    rescue Selenium::WebDriver::Error::NoSuchElementError
      return {}
    end

    welcome_message = description_element.text

    first_name = welcome_message.match(/Welcome back, (.*)!/)[1]

    return { first_name: first_name }
  end

  def get_product_info()
    sleep(2)

    search_results = @wrapper.find_element(:class, 'snize-search-results-content')

    products = search_results.find_elements(:class, 'snize-product')

    if !search_results.displayed?
      puts "No products found"
      return []
    end

    product_info = []
    products.each do |product|
        name = product.find_element(:class, 'snize-title').text
        price = product.find_element(:class, 'snize-price').text.gsub(/[^\d\.]/, '').to_f
        review = product.find_element(:class, 'total-reviews').text.gsub(/[^\d]/, '').to_i
        product_info << { name: name, price: price, review: review }
    end

    return product_info
  end

  def get_cart_info()
    sleep(2)
    @wrapper.get(@@BASE_URL + '/cart')

    cart_items = @wrapper.find_elements(:class, 'CartItem')
    cart_info = []

    if cart_items.empty?
      puts "Cart is empty"
      return cart_info
    end

    cart_items.each do |item|
      item_name = item.find_element(:class, 'CartItem__Title').text.strip.split.map(&:capitalize).join(' ')
      item_meta = item.find_element(:class, 'CartItem__Meta').text.strip
      item_color = item_meta.split('/')[0].strip.split.map(&:capitalize).join(' ')
      item_size = item_meta.match(/\d+/)[0]
      item_quantity = item.find_element(:class, 'QuantitySelector__CurrentQuantity').attribute('value').to_i

      cart_info << { name: item_name, color: item_color, size: item_size, quantity: item_quantity }
  end

    return cart_info
  end

  def close_popup()
    begin
      iframe_element = @wrapper.find_element(:class, 'webklipper-publisher-survey-container-~162ib61')
      if iframe_element
        puts "Popup detected"
        @wrapper.execute_script("arguments[0].remove()", iframe_element)
        sleep(5)
        puts "Popup closed"
      end
    rescue Selenium::WebDriver::Error::NoSuchElementError
    end
  end
  
  def popup_listener(func)
    popup_closed = false

    wrapper = lambda do |*args, **kwargs|
      if !popup_closed
        close_popup()
        popup_closed = true
      end

      return func.call(*args, **kwargs)
    end
  end

  def run()
    method_names = [:search, :sort, :add_to_cart, :update_cart, :remove_from_cart]
    method_names.each do |method_name|
      original_method = method(method_name)
      decorated_method = popup_listener(original_method)
      define_singleton_method(method_name) do |*args, **kwargs|
        decorated_method.call(*args, **kwargs)
      end
    end
    
    # Define test variables
    first_name = 'john'
    last_name = 'doe'
    email = 'johndoe@gmail.com'
    password = 'johndoe123'
    query = 'sneakers'
    view_mode = 'grid'
    sort_by = 'Title: A-Z'
    product_name = 'Wool Classic Sneakers'
    product_color = 'Midnight Blue'
    product_size = 7
    quantity = 1
    action = 'increase'
    flag = 0

    # Test login function
    login(email, password)
    account_info = get_account_info()
    if account_info[:first_name] == first_name
      puts "Login passed test"
      puts account_info
    else
      puts "Login failed test"
      flag = 1
    end

    # Test logout function
    logout()
    account_info = get_account_info()
    
    if flag.nil?
      puts "Logout passed test"
      puts account_info
    else
      puts "Logout failed test"
    end

    # Test search and sort functions
    search(query)
    product_info = get_product_info()
    if product_info.any? { |product| product[:name].downcase.include?(query.downcase) }
      puts "Search passed test"
      puts product_info
    else
      puts "Search failed test"
    end

    sort(view_mode, sort_by)
    product_info = get_product_info()
    if product_info.map { |product| product[:name] }.sort == product_info.map { |product| product[:name] }
        puts "Sort passed test"
        puts product_info
      else
        puts "Sort failed test"
      end

    # Test add to cart function
    add_to_cart(product_name, product_color, product_size)
    cart_info = get_cart_info()
    if cart_info.any? { |item| item[:name].downcase.include?(product_name.downcase) }
      puts "Add to cart passed test"
      puts cart_info
    else
      puts "Add to cart failed test"
    end

    # Test update cart function
    update_cart(product_name, product_color, product_size, action)
    cart_info = get_cart_info()

    if cart_info.any? { |item| item[:name].downcase.include?(product_name.downcase) }
      item = cart_info.find { |item| item[:name].downcase.include?(product_name.downcase) }

      if action == "increase"
        if item[:quantity] == quantity + 1
          puts "Update cart passed test"
          puts cart_info
        else
          puts "Update cart failed test"
        end
      elsif action == "decrease"
        if item[:quantity] == quantity - 1
          puts "Update cart passed test"
          puts cart_info
        else
          puts "Update cart failed test"
        end
      end
    else
      puts "Update cart failed test"
    end

    # Test remove from cart function
    remove_from_cart(product_name, product_color, product_size)
    cart_info = get_cart_info()
    if !cart_info.any? { |item| item[:name].downcase.include?(product_name.downcase) }
      puts "Remove from cart passed test"
      puts cart_info
    else
      puts "Remove from cart failed test"
    end
  end

  def quit()
    @wrapper.quit
  end
end


neemans = Neemans.new(ENV['CHROMEDRIVER'] || 'C:\Users\JasonGonsalves\Documents\Infuse\BLUE\chromedriver-win64\chromedriver.exe')

neemans.run()
neemans.quit()