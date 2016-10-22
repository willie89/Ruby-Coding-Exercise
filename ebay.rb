require 'net/http'
require 'fileutils'
require 'pry'

def get_tags
  #get tags
  #get tags
  #get tags
  #get test
  
end

def ask_product_name
  puts "What are you looking for?"
  product_name = gets.chomp
  product_name = product_name.tr(' ', '+').to_s
end

def ask_pages_to_scan
  puts "How many pages did you want to scan?"
  pages_to_scan = gets.chomp.to_i
end

def ask_markup
  puts "Whats the Mark Up?"
  markup = gets.chomp
end

def create_csv(product_name, number_of_pages_to_crawl, markup)
  File.write("rubyoutput/" + product_name + "PS" + number_of_pages_to_crawl.to_s + "MU" + markup.to_s + ".csv", "")
end

def get_description_url(url)
  str = URI.escape(url)
  uri = URI.parse(str)
  html_source = Net::HTTP.get(uri)
  html_source.match(/http:\/\/vi.vipr.ebaydesc(.*?)descgauge=1/m)[0]
end

def get_feature(url)
  description_url = get_description_url(url)
  if !description_url.nil?
    str = URI.escape(description_url)
    uri = URI.parse(str)
    html_source = Net::HTTP.get(uri)
    feature_match = html_source.match(/Feature(.*?)Package/m)
    if feature_match.nil?
      feature_match = html_source.match(/Basic Operations(.*?)Specifications/m)
    end
    if feature_match.nil?
      nil
    end
    if !feature_match.nil?
      feature = feature_match[0]
      clean_feature = feature.gsub(/<\/?[^>]*>/, "")
    end
  else 
    nil
  end
end

def start_scraping
  product_name = ask_product_name
  pages_to_scan = ask_pages_to_scan
  markup = ask_markup
  create_csv(product_name, pages_to_scan, markup)
  starting_page_number = 1
  scrape_page(starting_page_number, pages_to_scan,product_name, markup)
end

def write_to_csv(price,cleantitle,pic,mark_up,cleandescription,product_name,pages_crawled)
  if !price.nil? && !pic.nil? && !cleantitle.nil?
    pricetag = price.gsub(/,/, "").gsub(/<\/?[^>]*>/, "")
    pricetagint = pricetag.to_i*(1 + mark_up.to_i/100.00).round(-1)
    pricetag = pricetagint.to_s
    digit = pricetag.round(0).size
    if digit > 2
      pricetag.round(-1)
    else
      pricetag.round(0)
    end
    newline = "http://i.ebayimg.com/images/g/"+pic+'/s-l1000.jpg, '+'"'+cleantitle[0...50]+'"'+'"'+cleantitle+'"'+', $' + pricetag+','+'"'+cleandescription+'"'+'\n'
  end

  #open file and print to csv file
  open("rubyoutput/"+product_name.to_s+"PS"+pages_crawled.to_s+"MU"+mark_up.to_s+".csv", 'a') do |f|
  f.puts newline.to_s
  end
end

def parse_product_source(product)
  #not sure why this is an array...
  price = product[0].match(/bold\">(?:.*)\$(.*?)<\/span>/m)
  title = product[0].match(/class=\"vip\" title=\"(?:.*)\">(.*)(?:<\/a>)/m)
  pic = product[0].match(/thumbs(?:.*)images\/g\/(.*?)\/s-l/m)
  url = product[0].match(/http:\/\/www.ebay.com\/itm\/(.*?)\"/m)
  if !price.nil? && !title.nil? && !pic.nil? && !url.nil?
    # is there a better way to get [0] only when match is true
    {price: price[1], title: title[1], pic: pic[1], url: url[0]}
  else 
    {price: nil, title: nil, pic: nil, url: nil}
  end
end
def get_clean_text(source)
  source.gsub(/<\/?[^>]*>/, "").gsub(/\s+/, " ").gsub(/\t+/, " ").to_s
end

def get_product_list(product_name,page_number)  
  uri = URI("http://www.ebay.com/sch/i.html?_nkw="+product_name+"&_pgn="+page_number.to_s+"&_ipg=200&rt=nc&LH_BIN=1&LH_ItemCondition=1000")
  source = Net::HTTP.get(uri)
  source.scan(/class=\"sresult lvresult clearfix li(.*?)<\/li>/m)
end

def scrape_page(starting_page, pages_to_scan, product_name, mark_up)
  current_page = starting_page
  while current_page <= pages_to_scan do
      page_number = current_page
      products = get_product_list(product_name,page_number)
      products.each do |product_source|
        product = parse_product_source(product_source)

        if product[:url].nil?
          next
        end

        feature = get_feature(product[:url])
        title   = product[:title]
        price   = product[:price]
        pic     = product[:pic]
        
        if feature.nil?
          next
        end

        #Clean HTML tags
        cleandescription = get_clean_text(feature)
        cleantitle = get_clean_text(title)

        if price.nil? or title.nil? or pic.nil?
          next
        end
        if price.length < 2 or title.length < 10 or pic.length < 10 or cleandescription.length < 10
          next
        end
        #def write_to_csv(price,cleantitle,pic,mark_up,cleandescription)
        write_to_csv(price,cleantitle,pic,mark_up,cleandescription,product_name,pages_to_scan)
        puts "done"
      end
  end
      puts current_page
      current_page = current_page + 1
end
start_scraping

