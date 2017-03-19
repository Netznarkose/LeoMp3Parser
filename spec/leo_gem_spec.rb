require_relative '../lib/leo_gem'

describe '#compose_url' do
  it 'retuns correct default url' do
    correct_url = 'https://dict.leo.org/dictQuery/m-vocab/ende/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search=hello&searchLoc=0&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16'
    expect(compose_url).to eq(correct_url)
  end
end
