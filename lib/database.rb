# -*- coding: utf-8 -*-
require 'rubygems'
require 'sqlite3'

class Database
  attr_reader :db

  def initialize
    @db = SQLite3::Database.new("slice.db")
    sql = <<-SQL
    create table host(
      slice varchar(20),
      mac varchar(20)
    );
    SQL
    @db.execute(sql)
  end

  def close
    @db.execute("DROP TABLE host")
    @db.close
    p "database closed"
  end

  def slice?(slice)
    exist = false
    @db.results_as_hash = true
    @db.execute('select * from host where slice=?', slice) do |row|
      #rowは結果の配列
      #puts row.join("\t")
      exist = true if (row['mac'] == "")
    end
    return exist
  end

  def create_slice(slice)
    mac = ""
    @db.execute("insert into host values (?, ?)", slice, mac)
  end

  def add_host(slice, mac)
    @db.execute("insert into host values (?, ?)", slice, mac)
  end

  def delete_slice(slice)
    @db.execute("delete from host where slice=?", slice)
  end

  def delete_host(slice)
    @db.execute("delete from host where slice=?", slice)
  end

end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
