require 'selenium-webdriver'

class NeemansTesting
    @@BASE_URL = 'https://neemans.com'

  def initialize(driver_path, timeout = 60)
    Selenium::WebDriver::Chrome::Service.driver_path = driver_path
    @driver = Selenium::WebDriver.for :chrome
    @driver.manage.window.maximize
    @wait = Selenium::WebDriver::Wait.new(timeout: timeout)
  end

  def signup(first_name_value, last_name_value, email_value, password_value)
    @driver.get(@@BASE_URL + '/account/register')

    first_name = @driver.find_element(:name, 'customer[first_name]')
    last_name = @driver.find_element(:name, 'customer[last_name]')
    email = @driver.find_element(:name, 'customer[email]')
    password = @driver.find_element(:name, 'customer[password]')
    signup_button = @driver.find_element(:css, 'button[type="submit"]')

    if !first_name_value.match?(/^[a-zA-Z]+$/)
        puts "Invalid first name"
        return
    else
        first_name.send_keys(first_name_value)
    end

    if !last_name_value.match?(/^[a-zA-Z]+$/)
        puts "Invalid last name"
        return
    else
        last_name.send_keys(last_name_value)
    end

    if !email_value.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
        puts "Invalid email"
        return
    else
        email.send_keys(email_value)
    end

    if !password_value.match?^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$
        puts "Invalid password"
        return
    else
        password.send_keys(password_value)
    end

    original_url = @driver.current_url

    signup_button.click()

    @wait.until { @driver.current_url != original_url }

    if @driver.current_url == @@BASE_URL + '/challenge'
        puts 'Captcha encountered'
        return
    end

    sleep(5)
  end

  def login(email_value, password_value)
    @driver.get(@@BASE_URL + '/account/login')
    
    email = @driver.find_element(:name, 'customer[email]')
    password = @driver.find_element(:name, 'customer[password]')
    login_button = @driver.find_element(:css, 'button[type="submit"]')

    if !email_value.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
        puts "Invalid email"
        return
    else
        email.send_keys(email_value)
    end

    if !password_value.match?^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$
        puts "Invalid password"
        return
    else
        password.send_keys(password_value)
    end

    login_button.click()

    sleep(5)
  end

  def search(query)
    if !query.is_a?(String) || query.empty?
        puts 'Invalid query'
        return
    end

    @driver.get(@@BASE_URL + '/search')

    @driver.action.move_to(@driver.find_element(:tag_name, 'body')).perform()

    search_input = nil

    @wait.until { search_input = @driver.find_element(:css, 'input.Form__Input.snize-input-style') }

    search_input.send_keys(query)

    search_input.send_keys(:enter)

    @driver.action.move_to(@driver.find_element(:tag_name, 'body')).perform()

    @wait.until { @driver.find_elements(:class, 'snize-skeleton-card').empty? }

    sleep(5)
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

    if view_mode == 'grid'
        @driver.find_element(:css, '.snize-grid-mode-icon').click()
    elsif view_mode == 'list'
        @driver.find_element(:css, '.snize-list-mode-icon').click()
    else
        puts 'Invalid view mode'
        return
    end

    dropdown = @driver.find_element(:css, '.snize-main-panel-dropdown')

    dropdown.find_element(:css, '.snize-main-panel-dropdown-button').click()

    options = dropdown.find_elements(:css, '.snize-main-panel-dropdown-content a')

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

    sleep(5)
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

    @driver.get(@@BASE_URL + '/products/' + item)
    
    colour_list = @driver.find_element(:css, 'ul.ColorSwatchList')
    colour_options = colour_list.find_elements(:css, 'li')

    matching_option = colour_options.find { |option| option.attribute('data-value') == colour }
    if matching_option
        matching_option.click()
    else
        puts "Invalid colour option: #{colour}"
        return
    end

    sleep(5)

    size_list = @driver.find_element(:css, '.SizeSwatchList')
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

    add_to_cart_button = @driver.find_element(:css, '.ProductForm__AddToCart')
    add_to_cart_button.click()
    
    sleep(5)
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

    @driver.get(@@BASE_URL + '/cart')

    cart_items = @driver.find_elements(:css, '.CartItem')

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

    sleep(5)
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

    @driver.get(@@BASE_URL + '/cart')

    cart_items = @driver.find_elements(:css, '.CartItem')

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

    sleep(5)
  end

  def get_product_info()
    search_results = nil
    products = nil

    @wait.until { search_results = @driver.find_element(:class, 'snize-search-results-content') }

    @wait.until { products = search_results.find_elements(:class, 'snize-product') }

    product_info = []
    products.each do |product|
        name = product.find_element(:class, 'snize-title').text
        price = product.find_element(:class, 'snize-price').text.gsub(/[^\d\.]/, '').to_f
        review = product.find_element(:class, 'total-reviews').text.gsub(/[^\d]/, '').to_i
        product_info << { name: name, price: price, review: review }
    end

    return product_info
  end

  def run()
    signup('john', 'doe', 'johndoe@gmail.com', 'johndoe123')
    login('johndoe@gmail.com', 'johndoe123')
    search('sneakers')
    sort('grid', 'Title: A-Z')
    puts get_product_info()
    add_to_cart('Wool Classic Sneakers', 'Midnight Blue', 7)
    update_cart('Wool Classic Sneakers', 'Midnight Blue', 7, 'increase')
    remove_from_cart('Wool Classic Sneakers', 'Midnight Blue', 7)
  end

  def quit()
    @driver.quit
  end
end


neemans_testing = NeemansTesting.new('C:\Users\JasonGonsalves\Documents\Infuse\BLUE\chromedriver-win64\chromedriver.exe')
neemans_testing.run()
neemans_testing.quit()