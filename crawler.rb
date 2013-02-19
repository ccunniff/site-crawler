require "rubygems"
require "bundler/setup"

require "rest-client"
require "nokogiri"

# retrieve html page
doc = Nokogiri::HTML(RestClient.get("http://en.wikipedia.org/wiki/Baseball")) # <== insert your own Wikipedia link here
# get titles
titles = doc.css('div#bodyContent h2')
# get images
images = doc.search('div#bodyContent img')

# sort titles and image output
titles.each_with_index { |title, i|
  puts "#{i + 1}. #{title.inner_text}", "\n"

  # select images between current title and the next
  imagesForTitle = images.select { |image|
    if (i + 1) < titles.length
      (image.line > title.line) and (image.line < titles[i + 1].line)
    elsif (image.line > title.line)
      true
    end
  }

  # exclude magnify image from output
  imagesForTitle.each { |image|
    puts "- #{image['src']}", "\n" unless image['src'].include?("magnify-clip")
  }
}