require_relative '../lib/leo_gem'

describe '#compose_query' do
  it 'retuns correct default url' do
    correct_url = 'https://dict.leo.org/dictQuery/m-vocab/ende/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search=hello&searchLoc=0&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16'
    expect(compose_query).to eq(correct_url)
  end
end

describe '#instantiate_nokogiri_object' do
  it 'response with 200 for correct url' do
    correct_url = 'https://dict.leo.org/dictQuery/m-vocab/ende/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search=hello&searchLoc=0&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16'
    instantiate_nokogiri_object(correct_url).map do |response|
      expect(response).to eq(200)
    end
  end
  it 'response with an error-message for incorrect url' do
    false_url = 'false_url'
    expect(instantiate_nokogiri_object(false_url)).to eq(:danger)
  end
end
describe '#parse_audio_identifier' do
  it 'returns correct audio identifier' do
    correct_url = 'https://dict.leo.org/dictQuery/m-vocab/ende/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search=hello&searchLoc=0&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16'
    expect(parse_audio_identifier(correct_url)).to eq('iEUdzIwxBbMpDuh0x2yajA')
  end
  it 'returns an error-message for incorrect url' do
    false_url = 'false_url'
    expect(parse_audio_identifier(false_url)).to eq(:danger)
  end
end
describe '#compose_url' do
  it 'returns correct final url' do
    correct_url = 'https://dict.leo.org/dictQuery/m-vocab/ende/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search=hello&searchLoc=0&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16'
    expect(compose_url(correct_url)).to eq('https://dict.leo.org/media/audio/iEUdzIwxBbMpDuh0x2yajA.mp3')
  end
  # it 'returns an error-message for incorrect url' do
  #   false_url = 'false_url'
  #   expect(compose_final_url(false_url)).to eq(:danger)
  # end
end
