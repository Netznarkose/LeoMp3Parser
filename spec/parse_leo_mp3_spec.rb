require_relative '../lib/parse_leo_mp3'

RSpec.describe "parse_leo_mp3" do
  let(:parse_leo_mp3) { ParseLeoMp3.new }
  let(:correct_url) { 'https://dict.leo.org/dictQuery/m-vocab/ende/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search=hello&searchLoc=0&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16' }
  let(:false_url) { 'false_url' }

  describe '.compose_query' do
    it 'retuns correct default url' do
      expect(parse_leo_mp3.compose_query).to eq(correct_url)
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
