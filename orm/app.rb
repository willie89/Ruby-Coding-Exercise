require_relative 'photo'

# new_photo = Photo.new("https://placekitten.com/g/300/300")
# new_photo.save

photo = Photo.find(1)
puts "BEFORE:"
puts photo.inspect
photo.url = "www.google.com"
photo.save

puts
photo = Photo.find(1)
puts "AFTER:"
puts photo.inspect