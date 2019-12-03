require_relative "../config/environment.rb"
require "/home/oakesler/Development/awoke-cli/lib/story_object.rb"

require 'nokogiri'

require 'open-uri'
@story_hash = {:ACLU => " " , :Amnesty => " ", :HRW => " " , :SPLC => " ", :Backup => " "}


def the_aclu_headline_scraper
  html_aclu = open("https://www.aclu.org")
  doc_aclu = Nokogiri::HTML(html_aclu)
  step_1 = doc_aclu.css("div#hp__top_spotlight")
  headline_aclu = step_1.css("div")[4].children[0].text.strip
  #headline_aclu = doc_aclu.css('span.is-uppercase').text 
end

def the_amnesty_headline_scraper
  html_amnesty = open("https://www.amnesty.org/en/")
  doc_amnesty = Nokogiri::HTML(html_amnesty)
  headline_amnesty = "#{doc_amnesty.css('span.heading--tape').text}: #{doc_amnesty.css('p.image-headline__copy').text}"
  #headline_amnesty = doc_amnesty.css('span.heading--tape').text
  #headline_amnesty = "#{doc.css('span.heading--tape').text} : #{doc.css('p.image-headline__copy')}"
end

def the_hrw_headline_scraper
  html_hrw = open("https://www.hrw.org/#")
  doc_hrw = Nokogiri::HTML(html_hrw)
  headline_hrw = doc_hrw.css('h3.billboard-title').text
end

def the_splc_headline_scraper
  html_splc = open("https://www.splcenter.org")
  doc_splc = Nokogiri::HTML(html_splc)
  headline_splc = doc_splc.css("h1").first.text
end

def the_aclu_url_scraper
  html_aclu = open("https://www.aclu.org")
  doc_aclu = Nokogiri::HTML(html_aclu)
  step_1 = doc_aclu.css("div#hp__top_spotlight")
  step_2 = step_1.css("a")[0].to_a
  aclu_url = step_2[0][1]
  #step_a_1 = doc_aclu.css("div#hp__top_carousel")
  #step_a_2 = step_a_1.css("div.columns")
  #step_a_3 = step_a_2.children
  #step_a_4 = step_a_3[11]
  #step_a_5 = step_a_4.css("a").first
  #aclu_url = step_a_5.attributes["href"].value
end

def the_amnesty_url_scraper 
  html_amnesty = open("https://www.amnesty.org/en")
  doc_amnesty = Nokogiri::HTML(html_amnesty)
  step_1 = doc_amnesty.xpath('//div/a/@href')
  step_2 = step_1[9].text
  amnesty_url = "https://www.amnesty.org/#{step_2}"
end 

def the_hrw_url_scraper
  html_hrw = open("https://www.hrw.org")
  doc_hrw = Nokogiri::HTML(html_hrw)
  hrw_url = "https://www.hrw.org#{doc_hrw.css("h3.billboard-title a").map { |link| link["href"] }[0]}"
end

def the_splc_url_scraper
  html_splc = open("https://www.splcenter.org")
  doc_splc = Nokogiri::HTML(html_splc)
  step_1 = doc_splc.css("section#highlighted")
  step_2 = step_1.css("div.field-items")
  step_3 = step_2[0].children
  step_4 = step_3[1].children.text
  splc_url = step_4.match(/https.*\w/)
end

def the_aclu_abstract_scraper
  html_aclu = open("#{the_aclu_url_scraper}")
  doc_aclu = Nokogiri::HTML(html_aclu)
  aclu_abstract = "#{doc_aclu.css("p")[1].text}     #{doc_aclu.css("p")[2].text}"
  #aclu_abstract = doc_aclu.css("div#tabs").text
end

def the_amnesty_abstract_scraper
  html_amnesty = open("#{the_amnesty_url_scraper}")
  doc_amnesty = Nokogiri::HTML(html_amnesty)
  amnesty_abstract = doc_amnesty.css("p").text
end

def the_hrw_abstract_scraper
  html_hrw = open("#{the_hrw_url_scraper}")
  doc_hrw = Nokogiri::HTML(html_hrw)
  step_1 = doc_hrw.css("p")
  hrw_abstract = "#{step_1[4].text}   #{step_1[5].text}   #{step_1[6].text}"
end

def the_splc_abstract_scraper
  html_splc = open("#{the_splc_url_scraper}")
  doc_splc = Nokogiri::HTML(html_splc)
  splc_abstract = doc_splc.css("p").first.text
end

def aclu_object_maker
  aclu_story = Story.new("ACLU", "www.aclu.org")
  aclu_story.headline = the_aclu_headline_scraper
  aclu_story.story_url = the_aclu_url_scraper
  aclu_story.abstract = the_aclu_abstract_scraper
  @story_hash[:ACLU] = aclu_story
end

def amnesty_object_maker 
  amnesty_story = Story.new("Amnesty International USA", "www.amnestyusa.org")
  amnesty_story.headline = the_amnesty_headline_scraper
  amnesty_story.story_url = the_amnesty_url_scraper
  amnesty_story.abstract = the_amnesty_abstract_scraper
  @story_hash[:Amnesty] = amnesty_story
end

def hrw_object_maker
  hrw_story = Story.new("Human Rights Watch", "www.hrw.org")
  hrw_story.headline = the_hrw_headline_scraper
  hrw_story.story_url = the_hrw_url_scraper
  hrw_story.abstract = the_hrw_abstract_scraper
  @story_hash[:HRW] = hrw_story
end

def splc_object_maker
  splc_story = Story.new("Southern Poverty Law Center", "www.splcenter.org")
  splc_story.headline = the_splc_headline_scraper
  splc_story.story_url = the_splc_url_scraper
  splc_story.abstract = the_splc_abstract_scraper
  @story_hash[:SPLC] = splc_story
end

def execute_experiment
  aclu_object_maker
  amnesty_object_maker
  hrw_object_maker
  splc_object_maker
end

def welcome_menu
  puts "                                      "
  puts "Welcome to WokeApp! Select by story or use our randomizer."
	puts "For story selection, type ‘story'"
	puts "For randomizer, type ‘random'"
	puts "To exit, type ‘exit’"
	puts "                                     "
	input = gets.strip
	if input == "exit"
		puts "Thanks for using WokeApp!"
		elsif input == "story"
		story_selector
		elsif input == "random"
		randomizer
		else
		  menu_redirect
		end
  end 

def story_selector_segue
  puts "To go back to headlines, type 'headlines'"
  puts "To generate a random story, type 'random'"
  puts "To return to main menu, type 'menu'"
  puts "To exit WokeApp, type 'exit'"
  input = gets.strip
  if input == "headlines"
    story_selector
    elsif input == "menu"
    welcome_menu
    elsif input == "random"
    randomizer
    elsif input == "exit"
    puts "Thanks for using WokeApp!"
  else
    menu_redirect
  end
end

def story_selector
  puts "                         "
  puts "Please select a headline by number (1-4)"
  puts "                                         "
  puts "1. #{@story_hash[:ACLU].headline}"
  puts "2. #{@story_hash[:Amnesty].headline}"
  puts "3. #{@story_hash[:HRW].headline}"
  puts "4. #{@story_hash[:SPLC].headline}"
  puts "                                        "
  puts "...or type 'back' to return to the previous page"
  puts "                           "
  input = gets.strip
  if input == "1"
    puts "                      "
    puts "#{@story_hash[:ACLU].source} (#{@story_hash[:ACLU].home_url})"
    puts "                            "
    puts "#{@story_hash[:ACLU].headline}"
    puts "                           "
    puts "#{@story_hash[:ACLU].story_url}"
    puts "                            "
    puts "#{@story_hash[:ACLU].abstract}"
    puts "                             "
    story_selector_segue
    elsif input == "2"
    puts "                          "
    puts "#{@story_hash[:Amnesty].source} (#{@story_hash[:Amnesty].home_url})"
    puts "                           "
    puts "#{@story_hash[:Amnesty].headline}"
    puts "                            "
    puts "#{@story_hash[:Amnesty].story_url}"
    puts "                               "
    puts "#{@story_hash[:Amnesty].abstract}"
    puts "                                "
    story_selector_segue
    elsif input == "3"
    puts "                           "
    puts "#{@story_hash[:HRW].source} (#{@story_hash[:HRW].home_url})"
    puts "                            "
    puts "#{@story_hash[:HRW].headline}"
    puts "                             "
    puts "#{@story_hash[:HRW].story_url}"
    puts "                                 "
    puts "#{@story_hash[:HRW].abstract}"
    puts "                           "
    story_selector_segue
    elsif input == "4"
    puts "                             "
    puts "#{@story_hash[:SPLC].source} (#{@story_hash[:SPLC].home_url})"
    puts "                              "
    puts "#{@story_hash[:SPLC].headline}"
    puts "                               "
    puts "#{@story_hash[:SPLC].story_url}"
    puts "                               "
    puts "#{@story_hash[:SPLC].abstract}"
    puts "                               "
    story_selector_segue
    elsif input == "back"
    story_selector_segue
  else 
    menu_redirect
  end
end

def randomizer
  sample_array = [1, 2, 3, 4]
  x = sample_array.sample
  if x == 1
    puts "                            "
    puts "#{@story_hash[:ACLU].source} (#{@story_hash[:ACLU].home_url})"
    puts "                              "
    puts "#{@story_hash[:ACLU].headline}"
    puts "       "
    puts "#{@story_hash[:ACLU].story_url}"
    puts "          "
    puts "#{@story_hash[:ACLU].abstract}"
    puts "             "
    story_selector_segue
    elsif x == 2
    puts "                   "
    puts "#{@story_hash[:Amnesty].source} (#{@story_hash[:Amnesty].home_url})"
    puts "                     "
    puts "#{@story_hash[:Amnesty].headline}"
    puts "                        "
    puts "#{@story_hash[:Amnesty].story_url}"
    puts "                             "
    puts "#{@story_hash[:Amnesty].abstract}"
    puts "                              "
    story_selector_segue
    elsif x == 3
    puts "                              "
    puts "#{@story_hash[:HRW].source} (#{@story_hash[:HRW].home_url})"
    puts "                               "
    puts "#{@story_hash[:HRW].headline}"
    puts "                               "
    puts "#{@story_hash[:HRW].story_url}"
    puts "                               "
    puts "#{@story_hash[:HRW].abstract}"
    puts "                                "
    story_selector_segue
    elsif x == 4
    puts "                                "
    puts "#{@story_hash[:SPLC].source} (#{@story_hash[:SPLC].home_url})"
    puts "                                "
    puts "#{@story_hash[:SPLC].headline}"
    puts "                                "
    puts "#{@story_hash[:SPLC].story_url}"
    puts "                                "
    puts "#{@story_hash[:SPLC].abstract}"
    puts "                                 "
    story_selector_segue
  else 
    story_selector_segue
  end
end
  


