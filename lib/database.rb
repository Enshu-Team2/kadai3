# -*- coding: utf-8 -*-
require 'rubygems'
require 'sqlite3'

class Database

	@db = SQLite3::Database.new("slice.db")

	def initialize
    sql = <<-SQL
    create table host(
			slice varchar(20),
  		mac varchar(20)
    );
		SQL
    @db.execute(sql)
	end

	def slice?(slice)
		exist = false
		@db.results_as_hash = true
    @db.execute('select * from host where slice=?', slice) do |row|
      #rowは結果の配列
      #puts row.join("\t")
			if (row[mac] == "") exist = true
    end
		return exist
	end

	def create_slice(slice)
		mac = ""
		sql = "insert into host values (slice, mac)"
		@db.execute(sql)
	end

	def add_host(slice, mac)
		sql = "insert into host values (slice, mac)"
		@db.execute(sql)
	end

	def close
		@db.close
	end


end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
