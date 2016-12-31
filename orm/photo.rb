require 'pg'
require 'active_record'

class Photo < ActiveRecord::Base

  attr_accessor :url

  @@conn = PG::Connection.new(dbname: "orm_test")

  def initialize(url, id = nil)
    @url = url
    # @favorite = favorite
    @id = id
  end

  def save
    if @id.nil?
      @@conn.exec_params("INSERT INTO photos (url) VALUES ($1) returning id", [@url]);
    else
      @@conn.exec_params("UPDATE photos SET url = $1 WHERE id = $2",[@url, @id])
    end
  end

  def favorite
    @favorite = true
  end

  class << self

    def find_all
      results = []
      @@conn.exec_params("SELECT * FROM photos").each do |row|
        results << Photo.new(row["url"],row["id"])
      end
      puts results.inspect
    end

    def find(id)
      result = nil
      @@conn.exec_params("SELECT * FROM photos WHERE id = $1", [id]).each do |row|
        if id == row["id"].to_i
          result = Photo.new(row["url"],row["id"])
        end
      end
      result
    end
  end
end