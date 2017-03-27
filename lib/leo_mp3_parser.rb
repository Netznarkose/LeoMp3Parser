require 'nokogiri'
require 'open-uri'
class LeoMp3Parser
  def get_audio_url(language_and_term)
    validate_arguments(language_and_term)
    url = compose_query(language_and_term)
    compose_url(url)
  end

  private

  def validate_arguments(language_and_term)
    raise ArgumentError, 'Argument must be a Hash' unless language_and_term.is_a? Hash
    unless [:language, :term].all? { |key| language_and_term.key? key }
      raise ArgumentError, 'Keys must be :language and :term'
    end
    language_and_term.values.map do |value|
      raise ArgumentError, 'Values must be Strings' unless value.is_a? String
    end
    language_and_term.values.map do |value|
      raise ArgumentError, 'Values can not be emtpy' if value.empty?
    end
    unless ['ende', 'esde', 'frde'].any? { |language| language_and_term[:language] == language }
      raise ArgumentError, 'Language must be set to ende, esde or frde'
    end
  end

  def compose_query(language_and_term)
    url = 'https://dict.leo.org/dictQuery/m-vocab/' << language_and_term[:language]
    url << '/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search='
    url << language_and_term[:term]
    url << '&searchLoc=0&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16'
  end

  def compose_url(url)
    "https://dict.leo.org/media/audio/#{parse_audio_identifier(url)}.mp3"
  end

  def parse_audio_identifier(url)
    instantiate_nokogiri_object(url).at_css('pron').first[1]
  rescue
    raise_customized_exception
  end

  def instantiate_nokogiri_object(url)
    Nokogiri::XML(open(url))
  rescue
    raise_customized_exception
  end

  def raise_customized_exception
    raise StandardError, 'Nokogiri throws an exception'
  end
end
