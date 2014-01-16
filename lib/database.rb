# -*- coding: utf-8 -*-
require 'rubygems'
require 'sqlite3'

class Database

  def initialize
    @db = SQLite3::Database.new("slice.db")
    tables = @db.execute("SELECT tbl_name FROM sqlite_master WHERE type == 'table'").flatten
    if tables.include?("host")
      @db.execute("DROP TABLE host")
    end
    sql = <<-SQL
    create table host(
      slice varchar(20),
      mac varchar(20)
    );
    SQL
    @db.execute(sql)
  end

  def close_db
    @db.execute("DROP TABLE host")
    @db.close
    p "database closed"
  end

  def slice?(slice)
    exist = false
    @db.results_as_hash = true
    @db.execute('select * from host where slice=?', slice) do |row|
      exist = true if (row['mac'] == "")
    end
    return exist
  end

  def host?(mac)
    exist = false
    @db.results_as_hash = true
    @db.execute('select * from host where mac=?', mac.to_s) do |row|
      exist = true
    end
    return exist
  end

  def search_slice(mac)
    name = false
    @db.results_as_hash = true
    @db.execute('select * from host where mac=?', mac.to_s) do |row|
      name = row['slice']
    end
    return name
  end

  def get_hosts(slice)
    list = []
    @db.results_as_hash = true
    @db.execute('select * from host where slice=?', slice) do |row|
      list.push(row['mac']) unless (row['mac'] == "")
    end
    return list
  end

  def create_slice(slice)
    mac = ""
    @db.execute("insert into host values (?, ?)", slice, mac)
  end

  def add_host(slice, mac)
    @db.execute("insert into host values (?, ?)", slice, mac.to_s)
  end

  def delete_slice(slice)
    @db.execute("delete from host where slice=?", slice)
  end

  def delete_host(mac)
    @db.execute("delete from host where mac=?", mac.to_s)
  end

end

