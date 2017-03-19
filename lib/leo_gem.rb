require 'pry-byebug'
require 'nokogiri'
require 'open-uri'
class ParseLeoMp3
  attr_accessor :language, :term
  attr_reader :url
  def initialize(input_hash = {})
    @language = input_hash[:language] || 'ende'
    @term = input_hash[:term] || 'hello'
    @url = compose_query(@language, @term)
  end

  def compose_query(language = 'ende', search_term = 'hello')
    url = 'https://dict.leo.org/dictQuery/m-vocab/' << language
    url << '/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search='
    url << search_term
    url << '&searchLoc=0&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16'
  end

  def instantiate_nokogiri_object(url)
    Nokogiri::XML(open(url))
  rescue
    :danger
  end

  def parse_audio_identifier(url)
    instantiate_nokogiri_object(url).at_css('pron').first[1]
  rescue
    :danger
  end

  def compose_url(url)
    "https://dict.leo.org/media/audio/#{parse_audio_identifier(url)}.mp3"
  end
end
