# app/controllers/screenshots_controller.rb

class ScreenshotsController < ApplicationController
  def index
    # Empty action for rendering the index view
  end

  def success
    # Nothing to do here, we'll just render the view
  end

  def capture
    url = params[:url]

    # Set up the Selenium webdriver with headless Chrome
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--disable-gpu')
    options.add_argument('--window-size=1280x1024')

    driver = Selenium::WebDriver.for :chrome, options: options

    # Navigate to the URL and capture the screenshot
    driver.get(url)
    screenshot = driver.screenshot_as(:png)
    
    # Save the screenshot to a local file
    file_path = '/home/ads/Documents/screenshot.png'
    File.open(file_path, 'wb') { |f| f.write(screenshot) }

    # Quit the driver
    driver.quit

     # Set instance variables for the view
     flash[:message] = "Screenshot captured and saved to #{file_path}"
    #  flash[:screenshot_url] = file_path
 
     redirect_to success_screenshots_path
   end
 end