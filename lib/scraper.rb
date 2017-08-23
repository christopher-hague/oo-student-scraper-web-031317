require 'open-uri'
require 'byebug'

class Scraper

  def self.scrape_index_page(index_url)
    # get name, location and profile_url
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    student_cards = doc.css(".student-card")

    students = student_cards.map do |card|
      student = {}
      student[:name] = card.css(".card-text-container .student-name").text
      student[:location] = card.css(".card-text-container .student-location").text
      student[:profile_url] = "./fixtures/student-site/" + card.css("a").attribute("href").text
      student
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    social_media = doc.css(".social-icon-container a")

    student_info = {}

    student_info[:profile_quote] = doc.css(".vitals-text-container .profile-quote").text if doc.css(".vitals-text-container .profile-quote")
    student_info[:bio] = doc.css(".bio-content p").text if doc.css(".bio-content p")

    social_media.each do |site|
      url = site.attribute("href").text
      if url.include?("twitter")
        student_info[:twitter] = url
      elsif url.include?("linkedin")
        student_info[:linkedin] = url
      elsif url.include?("github")
        student_info[:github] = url
      else
        student_info[:blog] = url
      end
    end

    student_info
  end

end
