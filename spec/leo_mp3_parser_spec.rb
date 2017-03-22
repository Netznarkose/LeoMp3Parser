require_relative '../lib/leo_mp3_parser'

RSpec.describe 'leo_mp3_parser' do
  let(:leo_mp3_parser) { LeoMp3Parser.new }
  let(:correct_url) { 'https://dict.leo.org/dictQuery/m-vocab/ende/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search=hello&searchLoc=0&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16' }
  let(:false_url) { 'false_url' }
  let(:language_and_term) { { language: 'ende', term: 'hello' } }

  describe '.validate_arguments' do
    it 'does not raise an error whith correct arguments' do
      expect { leo_mp3_parser.validate_arguments(language_and_term) }.not_to raise_error
    end
    it 'raises an error when argument is not a hash' do
      expect { leo_mp3_parser.validate_arguments('not a hash') }.to raise_error(ArgumentError, 'Argument must be a Hash')
    end
    it 'raises an error when keys are not :language and :term' do
      expect { leo_mp3_parser.validate_arguments(number: 'ende', color: 'hello') }.to raise_error(ArgumentError, 'Keys must be :language and :term')
    end
    it 'raises an error when values are not Strings' do
      expect { leo_mp3_parser.validate_arguments(language: 23, term: :blue) }.to raise_error(ArgumentError, 'Values must be Strings')
    end
    it 'raises an error when values are empty' do
      expect { leo_mp3_parser.validate_arguments(language: '', term: '') }.to raise_error(ArgumentError, 'Values can not be emtpy')
    end
    it 'raises an error unless language is ende, esde or frde' do
      expect { leo_mp3_parser.validate_arguments(language: 'wrong_language_selection', term: 'hello') }.to raise_error(ArgumentError, 'Language must be set to ende, esde or frde')
    end
  end
  describe '.compose_query' do
    it 'retuns correct default url' do
      expect(leo_mp3_parser.compose_query(language_and_term)).to eq(correct_url)
    end

    describe '.instantiate_nokogiri_object' do
      it 'response with 200 for correct url' do
        leo_mp3_parser.instantiate_nokogiri_object(correct_url).map do |response|
          expect(response).to eq(200)
        end
      end
      it 'raises an exception when url is false' do
        expect { leo_mp3_parser.instantiate_nokogiri_object(false_url) }.to raise_error(StandardError, 'Nokogiri throws an exception')
      end
    end
    describe '.parse_audio_identifier' do
      it 'returns correct audio identifier' do
        expect(leo_mp3_parser.parse_audio_identifier(correct_url)).to eq('iEUdzIwxBbMpDuh0x2yajA')
      end
      it 'raises an exception when url is false' do
        expect{ leo_mp3_parser.parse_audio_identifier(false_url) }.to raise_error(StandardError, 'Nokogiri throws an exception')
      end
    end
    describe '.compose_url' do
      it 'composes correct final url' do
        expect(leo_mp3_parser.compose_url(correct_url)).to eq('https://dict.leo.org/media/audio/iEUdzIwxBbMpDuh0x2yajA.mp3')
      end
    end
  end
end
