require 'net/http'
require 'fileutils'

#whatever, bro

puts "What are you looking for?"
productName = gets.chomp
productName = productName.tr(' ', '+').to_s
puts "How many pages did you want to scan?"
pagesCrawled = gets.chomp.to_i
puts "Whats the MarkUp?"
markUp = gets.chomp.to_i
pgn = 1

	# testing enviroment
		# # address = descurl[0]
		# # str = URI.escape(address)
	# 	# uri = URI.parse(str)

		# uri = URI("http://www.ebay.com/itm/Meike-MK-28mm-F2-8-Large-Aperture-Manual-Focus-Lens-for-Sony-E-Mount-NEX3-3N-5-6-/252504383955?hash=item3aca6f21d3:g:lXkAAOSw0UdXtV~Y")
		# # uri = URI("http://vi.vipr.ebaydesc.com/ws/eBayISAPI.dll?ViewItemDescV4&item=252080123937&t=1443172783000&tid=10&category=48515&seller=meidike88&excSoj=1&excTrk=1&lsite=0&ittenable=false&domain=ebay.com&descgauge=1")
		# source = Net::HTTP.get(uri)
		# #Get detail link
		# puts descurl = source.match(/http:\/\/vi.vipr.ebaydesc(.*?)descgauge=1/m)
		# #Find link to description area
		# # uri = URI(descurl[0].to_s)
		# address = descurl[0]
		# str = URI.escape(address)
	#    uri = URI.parse(str)
		# source2 = Net::HTTP.get(uri)
		# #Find section for Feature and copy description
		# puts feat1 = source2.match(/Feature(.*?)Package/m)
		# #Clean HTML tags
		# cleandesription = feat1[0].gsub(/<\/?[^>]*>/, "")
	# end testing enviroment

	File.write("rubyoutput/"+productName.to_s+"PS"+pagesCrawled.to_s+"MU"+markUp.to_s+".csv", "")

while pgn <= pagesCrawled do
	uri = URI("http://www.ebay.com/sch/i.html?_nkw="+productName+"&_pgn="+pgn.to_s+"&_ipg=200&rt=nc&LH_BIN=1&LH_ItemCondition=1000")
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
				pricetagint = pricetag.to_i*(1 + markUp/100.00)
				pricetag = pricetagint.to_s
				newline = "http://i.ebayimg.com/images/g/"+pic[1]+'/s-l1000.jpg, '+'"'+cleantitle[0...50]+'"'+'"'+cleantitle+'"'+', $' + pricetag+','+'"'+cleandescription+'"'+'\n'
			end

			#open file and print to csv file
			open("rubyoutput/"+productName.to_s+"PS"+pagesCrawled.to_s+"MU"+markUp.to_s+".csv", 'a') do |f|
				f.puts newline.to_s
		end
		n += 1
		puts n
	end
	pgn += 1
end

# class ebayRipper

# 	def initialize(productName,pagesCrawled,markUp,x)
# 		@x = x
# 		@productName = productName
# 		@pagesCrawled = pagesCrawled
# 		@markUp = markUp
# 	end

# 	get

# 	def productInfo

# 	end

# 	def writeFile
# 	end
end