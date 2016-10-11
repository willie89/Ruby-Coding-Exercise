require 'net/http'
require 'fileutils'

#test est test
		
puts "What are you looking for?"
product_name = gets.chomp
product_name = product_name.tr(' ', '+').to_s
puts "How many pages did you want to scan?"
pages_crawled = gets.chomp.to_i
puts "Whats the Mark up?"
mark_up = gets.chomp.to_i
pgn = 1

def get_description_url(url)
	uri = URI(url)
	source = Net::HTTP.get(uri)
	source.match(/http:\/\/vi.vipr.ebaydesc(.*?)descgauge=1/m)[0]		
end

def get_feature(url)
	description_url = get_description_url(url)
	str = URI.escape(description_url)
  uri = URI.parse(str)
	html_source = Net::HTTP.get(uri)
	feature = html_source.match(/Feature(.*?)Package/m)[0]
	clean_feature = feature.gsub(/<\/?[^>]*>/, "")			
end

# test_url = "http://www.ebay.com/itm/Meike-MK-28mm-F2-8-Large-Aperture-Manual-Focus-Lens-for-Sony-E-Mount-NEX3-3N-5-6-/252504383955?hash=item3aca6f21d3:g:lXkAAOSw0UdXtV~Y"
# get_feature(test_url)



	File.write("rubyoutput/"+product_name.to_s+"PS"+pages_crawled.to_s+"MU"+mark_up.to_s+".csv", "")

while pgn <= pages_crawled do
	uri = URI("http://www.ebay.com/sch/i.html?_nkw="+product_name+"&_pgn="+pgn.to_s+"&_ipg=200&rt=nc&LH_BIN=1&LH_ItemCondition=1000")
	source = Net::HTTP.get(uri)
	#class="gspr next" href="http://www.ebay.com/sch/Battery-Grips/29967/i.html?Brand=Meike&amp;_pgn=2&amp;_skc=200&amp;rt=nc"></a>

	#Get the next button so we can redo
	#the loop this must be inside the method
	#Sept 19th 2016
	# nextbtn = source.scan(/label=\"Next page of results\"(?:.*)href=\"(.*?)\"/m)
	# p nextbt	n
	products = source.scan(/class=\"sresult lvresult clearfix li(.*?)<\/li>/m)
	n = 0
	products.each do |x|

			scanprod = x[0]
			#find price, title, pic, url
			price = scanprod.match(/bold\">(?:.*)\$(.*?)<\/span>/m)
			title = scanprod.match(/class=\"vip\" title=\"(?:.*)\">(.*)(?:<\/a>)/m)
			pic = scanprod.match(/thumbs(?:.*)images\/g\/(.*?)\/s-l/m)
			url = scanprod.match(/http:\/\/www.ebay.com\/itm\/(.*?)\"/m)
		if(url == nil)
			#break for promote products
			next
		end



		#Get detail link
		address = url[0]
		str = URI.escape(address)
	   	uri = URI.parse(str)
		source2 = Net::HTTP.get(uri)
		descurl = source2.match(/http:\/\/vi.vipr.ebaydesc(.*?)descgauge=1/m)
		#Find link to description area
		# uri = URI(descurl[0].to_s)
		if(descurl == nil)
			#break for promote products
			next
		end
		address = descurl[0]
		str = URI.escape(address)
		uri = URI.parse(str)
		source3 = Net::HTTP.get(uri)
		#Find section for Feature and copy description
		feat1 = source3.match(/Feature(.*?)Package/m)
		if feat1 == nil
			feat1 = source3.match(/Basic Operations(.*?)Specifications/m)
		end
		if feat1 == nil
			next
		end
		#Clean HTML tags
		cleandescription = feat1[0].gsub(/<\/?[^>]*>/, "").gsub(/\s+/, " ").gsub(/\t+/, " ").to_s
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
		n += 1
		puts n
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