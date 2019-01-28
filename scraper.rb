require 'open-uri'
require 'nokogiri'
require_relative 'recipe'

class Scraper
  attr_reader :scraped_titles, :scraped_description, :scraped_time, :scraped_difficulty

  def initialize(keyword, difficulty = "")
    @url = 'https://www.marmiton.org/recettes/recherche.aspx?aqt='
    @keyword = keyword
    @difficulty = difficulty
    @scraped_titles = scrape_title
    @scraped_description = scrape_description
    @scraped_time = scrape_time
    @scraped_difficulty = scrape_difficulty
  end

  def scrape_title
    @difficulty == "" ? html_file = open(@url + @keyword).read : html_file = open(@url + @keyword + "&dif=" + @difficulty).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search('.recipe-card__title').take(5).map { |element| element.text.strip }
  end

  def scrape_description
    @difficulty == "" ? html_file = open(@url + @keyword).read : html_file = open(@url + @keyword + "&dif=" + @difficulty).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search('.recipe-card__description').take(5).map { |element| element.text.strip }
  end

  def scrape_time
    @difficulty == "" ? html_file = open(@url + @keyword).read : html_file = open(@url + @keyword + "&dif=" + @difficulty).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search('.recipe-card__duration__value').take(5).map { |element| element.text.strip }
  end

  def scrape_difficulty
    @difficulty == "" ? html_file = open(@url + @keyword).read : html_file = open(@url + @keyword + "&dif=" + @difficulty).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search('.recipe-card-link').take(5).map do |element|
      html_file_recipe = open("https://www.marmiton.org" + element.attribute('href').value).read
      html_doc_recipe = Nokogiri::HTML(html_file_recipe)
      html_doc_recipe.search('.recipe-infos__level').map { |subelement| subelement.text.strip }.join
    end
  end
end

