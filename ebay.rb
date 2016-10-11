require 'net/http'
require 'fileutils'

page_number = 1

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
	File.write("rubyoutput/" + product_name + "PS" + number_of_pages_to_crawl + "MU" + markup + ".csv", "")
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
    feature = html_source.match(/Feature(.*?)Package/m)[0]
    if feature.nil?
      feature = html_source.match(/Basic Operations(.*?)Specifications/m)[0]
    end
    if feature.nil?
      nil
    end

    clean_feature = feature.gsub(/<\/?[^>]*>/, "")
  else 
    nil
  end
end

def start_scraping
	product_name = ask_product_name
	pages_to_scan = ask_pages_to_scan
	markup = ask_markup
	create_csv(product_name, pages_to_scan, markup)
end

# test_url = "http://www.ebay.com/itm/Meike-MK-28mm-F2-8-Large-Aperture-Manual-Focus-Lens-for-Sony-E-Mount-NEX3-3N-5-6-/252504383955?hash=item3aca6f21d3:g:lXkAAOSw0UdXtV~Y"
# get_feature(test_url)

start_scraping


def parse_product_source(product)
  price = product.match(/bold\">(?:.*)\$(.*?)<\/span>/m)[1]
  title = product.match(/class=\"vip\" title=\"(?:.*)\">(.*)(?:<\/a>)/m)[1]
  pic = product.match(/thumbs(?:.*)images\/g\/(.*?)\/s-l/m)[1]
  url = product.match(/http:\/\/www.ebay.com\/itm\/(.*?)\"/m)[1]
  {price: price, title: title, pic: pic, url: url}
end

def get_product_list(product_name,page_number)
  uri = URI("http://www.ebay.com/sch/i.html?_nkw="+product_name+"&_pgn="+page_number.to_s+"&_ipg=200&rt=nc&LH_BIN=1&LH_ItemCondition=1000")
  source = Net::HTTP.get(uri)
  source.scan(/class=\"sresult lvresult clearfix li(.*?)<\/li>/m)[0]
end

while page_number <= pages_crawled do


  products = get_product_list(product_name,page_number)
  
	products.each_with_index do |product_source,index|
    puts index
    product = parse_product_source(product_source)

		if product[:url].nil?
			next
		end

    feature = get_feature(product[:url])
    
    if feature.nil?
      next
    end

		#Clean HTML tags
		cleandescription = feature.gsub(/<\/?[^>]*>/, "").gsub(/\s+/, " ").gsub(/\t+/, " ").to_s
		cleantitle = title[1].gsub(/<\/?[^>]*>/, "").gsub(/\s+/, " ").gsub(/\t+/, " ").to_s
		#make sure there is no style tags
		#remove nbsp
		#one cell csv
		if price == nil or title == nil or pic == nil
			next
		end
		if price[1].length < 2 or title[1].length < 10 or pic[1].length < 10 or cleandescription.length < 10
			next
		end
		#Check if price and title are filled if they are not then ignore the post
		#They are empty if its a sponsored item or not a correct list item


		def write_to_csv price,title,pic,cleantitle
			if price[1] != nil && title[1] != nil && pic[1] != nil && cleantitle != nil
				puts pricetag = price[1].gsub(/<\/?[^>]*>/, "")
				pricetagint = pricetag.to_i*(1 + mark_up/100.00)
				pricetag = pricetagint.to_s
				newline = "http://i.ebayimg.com/images/g/"+pic[1]+'/s-l1000.jpg, '+'"'+cleantitle[0...50]+'"'+'"'+cleantitle+'"'+', $' + pricetag+','+'"'+cleandescription+'"'+'\n'
			end

			#open file and print to csv file
			open("rubyoutput/"+product_name.to_s+"PS"+pages_crawled.to_s+"MU"+mark_up.to_s+".csv", 'a') do |f|
				f.puts newline.to_s
		end
	end
	pgn += 1
end

# class ebayRipper

# 	def initialize(product_name,pages_crawled,mark_up,x)
# 		@x = x
# 		@product_name = product_name
# 		@pages_crawled = pages_crawled
# 		@mark_up = mark_up
# 	end

# 	get

# 	def productInfo

# 	end

# 	def writeFile
# 	end
end