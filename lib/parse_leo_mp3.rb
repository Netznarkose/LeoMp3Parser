require 'pry-byebug'
require 'nokogiri'
require 'open-uri'
class ParseLeoMp3
  # attr_accessor :language_and_term
  # def initialize(language_and_term = {})
  #   validate_arguments(language_and_term)
  #   @language_and_term = language_and_term
  # end

  def validate_arguments(language_and_term)
    raise ArgumentError.new('argument must be a Hash') unless language_and_term.is_a? Hash
    raise ArgumentError.new('Keys must be :language and :term') unless (language_and_term.keys.include?(:language) && language_and_term.keys.include?(:term))
    language_and_term.values.map do |value|
      raise ArgumentError.new('Values must be Strings') unless value.is_a? String
    end
    language_and_term.values.map do |value|
      raise ArgumentError.new('Values can not be emtpy') if value.empty?
    end
    raise ArgumentError.new('Language must be set to ende, esde or frde') unless (language_and_term[:language].include?('ende') || language_and_term[:language].include?('esde') || language_and_term[:language].include?('frde'))
  end

  def get_audio_url(language_and_term)
    validate_arguments(language_and_term)
    url = compose_query(language_and_term)
    compose_url(url)
  end

  def compose_query(language_and_term)
    url = 'https://dict.leo.org/dictQuery/m-vocab/' << language_and_term[:language]
    url << '/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search='
    url << language_and_term[:term]
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
