class ScreenshotsController < ApplicationController
  def index; end

  def success
    @screenshot = Screenshot.last
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
    screenshot_data = driver.screenshot_as(:png)

    # Save the screenshot to a local file
    file_path = '/home/ads/Documents/screenshot.png'
    File.open(file_path, 'wb') { |f| f.write(screenshot_data) }

    # Save the screenshot to Active Storage
    screenshot = Screenshot.new(title: 'Captured Screenshot')
    screenshot.image.attach(io: StringIO.new(screenshot_data), filename: 'screenshot.png', content_type: 'image/png')
    
    if screenshot.save
      flash[:message] = "Screenshot captured and saved successfully."
    else
      flash[:message] = "Failed to save the screenshot."
    end

    # Quit the driver
    driver.quit

    redirect_to success_screenshots_path
  end
end
