# app/controllers/screenshots_controller.rb

class ScreenshotsController < ApplicationController
  def index
    # Empty action for rendering the index view
  end

  def success
    @screenshot = Screenshot.last
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
    screenshot_data = driver.screenshot_as(:png)

    # Quit the driver
    driver.quit

    # Create a temporary file to store the screenshot data
    temp_file = Tempfile.new(['screenshot', '.png'], binmode: true)
    temp_file.write(screenshot_data)
    temp_file.rewind

    # Save the screenshot to Cloudinary
    upload_result = Cloudinary::Uploader.upload(temp_file.path)
    cloudinary_url = upload_result['secure_url']

    # Close and delete the temporary file
    temp_file.close
    temp_file.unlink

    # Save the screenshot to Active Storage
    screenshot = Screenshot.new(title: 'Captured Screenshot')
    screenshot.image.attach(io: StringIO.new(screenshot_data), filename: 'screenshot.png', content_type: 'image/png')

    if screenshot.save
      flash[:message] = "Screenshot captured and saved successfully."
    else
      flash[:message] = "Failed to save the screenshot."
    end

    redirect_to success_screenshots_path
  end
end
