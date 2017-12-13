require "selenium-webdriver"

DELIMITER = ','


print "target URI: "
target = STDIN.gets.strip
print "count: "
count = STDIN.gets.strip.to_i
print "smart phone? (y/n): "
is_sp = STDIN.gets.strip[0] == "y"

result = count.times.map {|i|
  options = Selenium::WebDriver::Chrome::Options.new
  if is_sp
    options.add_argument '--user-agent=Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36'

  end

  driver = Selenium::WebDriver.for :chrome, options: options

  driver.capabilities[:acceptSslCerts] = true
  driver.capabilities[:enableElementCacheCleanup] = true

  driver.get target

  start_time = driver.execute_script "return window.performance.timing.requestStart"
  dcl_end_time = driver.execute_script "return window.performance.timing.domContentLoadedEventEnd"
  load_end_time = driver.execute_script "return window.performance.timing.loadEventEnd"

  puts "DOMContentLoaded: #{dcl_end_time - start_time}"
  puts "load: #{load_end_time - start_time}"

  driver.quit

  [
    (dcl_end_time - start_time).to_f / 1000,
    (load_end_time - start_time).to_f / 1000
  ]
}

puts result.map(&:first).join DELIMITER
puts result.map(&:last).join DELIMITER
