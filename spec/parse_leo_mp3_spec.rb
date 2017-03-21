require_relative '../lib/parse_leo_mp3'

RSpec.describe "parse_leo_mp3" do
  let(:parse_leo_mp3) { ParseLeoMp3.new }
  let(:correct_url) { 'https://dict.leo.org/dictQuery/m-vocab/ende/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search=hello&searchLoc=0&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16' }
  let(:false_url) { 'false_url' }
  let(:language_and_term) { { language: 'ende', term: 'hello' } }

  describe '.validate_arguments' do
    it 'does not raise an error whith correct arguments' do
      expect{ parse_leo_mp3.validate_arguments(language_and_term) }.not_to raise_error
    end
    it 'raises an error when argument is not a hash' do
      expect { parse_leo_mp3.validate_arguments('not a hash') }.to raise_error(ArgumentError, 'argument must be a Hash')
    end
    it 'raises an error when keys are not :language and :term' do
      expect { parse_leo_mp3.validate_arguments({ number: 'ende', color: 'hello' }) }.to raise_error(ArgumentError, 'Keys must be :language and :term')
    end
    it 'raises an error when values are not Strings' do
      expect { parse_leo_mp3.validate_arguments({ language: 23, term: :blue }) }.to raise_error(ArgumentError, 'Values must be Strings')
    end
    it 'raises an error when values are empty' do
      expect { parse_leo_mp3.validate_arguments({ language: '', term: '' }) }.to raise_error(ArgumentError, 'Values can not be emtpy')
    end
    it 'raises an error unless language is ende, esde or frde' do
      expect { parse_leo_mp3.validate_arguments({ language: 'wrong_language_selection', term: 'hello' }) }.to raise_error(ArgumentError, 'Language must be set to ende, esde or frde')
    end
  end
  describe '.compose_query' do
    it 'retuns correct default url' do
      expect(parse_leo_mp3.compose_query(language_and_term)).to eq(correct_url)
    end

    describe '.instantiate_nokogiri_object' do
      it 'response with 200 for correct url' do
        parse_leo_mp3.instantiate_nokogiri_object(correct_url).map do |response|
          expect(response).to eq(200)
        end
      end
      it 'rescues with :danger when url is false' do
        expect(parse_leo_mp3.instantiate_nokogiri_object(false_url)).to eq(:danger)
      end
    end
    describe '.parse_audio_identifier' do
      it 'returns correct audio identifier' do
        expect(parse_leo_mp3.parse_audio_identifier(correct_url)).to eq('iEUdzIwxBbMpDuh0x2yajA')
      end
      it 'rescues with :danger when url is false' do
        expect(parse_leo_mp3.parse_audio_identifier(false_url)).to eq(:danger)
      end
    end
    describe '.compose_url' do
      it 'composes correct final url' do
        expect(parse_leo_mp3.compose_url(correct_url)).to eq('https://dict.leo.org/media/audio/iEUdzIwxBbMpDuh0x2yajA.mp3')
      end
    end
  end
end
