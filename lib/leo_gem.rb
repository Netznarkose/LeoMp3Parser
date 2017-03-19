def compose_url(language = 'ende', search_term = 'hello')
  url = 'https://dict.leo.org/dictQuery/m-vocab/' << language
  url << '/query.xml?tolerMode=nof&lp=ende&lang=en&rmWords=off&rmSearch=on&directN=0&search='
  url << search_term
  url << '&searchLoc=0&resultOrder=basic&multiwordShowSingle=on&sectLenMax=16'
end
