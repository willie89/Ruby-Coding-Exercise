require 'pg'

class Connection

  def connect
    PG::Connection.new(dbname: "orm_test")
  end

end