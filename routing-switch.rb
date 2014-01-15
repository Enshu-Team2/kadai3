# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path(File.join File.dirname(__FILE__), 'lib')
 
require 'rubygems'
require 'bundler/setup'
 
require 'command-line'
require 'topology'
require 'trema'
require 'trema-extensions/port'
require 'data_base'
 
require 'thread'
require 'sqlite3'
 
#
# Routing Switch using LLDP to collect network topology information.
#
class RoutingSwitch < Controller
  periodic_timer_event :flood_lldp_frames, 1
  periodic_timer_event :check_queue, 1
  FLOWHARDTIMEOUT = 300
 
  def start
    @fdb = {}
    @adb = {}
    @slice = {}
    @slice_reverse = {}
    @command_line = CommandLine.new
    @command_line.parse(ARGV.dup)
    @topology = Topology.new(@command_line)
    @db = Database.new
 
    @queue = Queue.new
    @thread = Thread.new do
      loop do
        input = $stdin.gets
        args = input.split(" ")
        parser(args)
      end
    end
  end
 
  def parser(args)
                                if args.length > 2
                                  begin
                                    mac = Mac.new(args[2].to_s)
                                  rescue
                                          p "Input Error: Invalid mac address."
                                          return
                                  end
                                end
 
                            case args[0]
                                          when "create-slice"
                                                        if (args.length == 2)
                                                                      @queue.push([args[0],args[1]])
                                                        else
                                                                      p "Usage: create-slice slice"
                                                        end
                                          when "delete-slice"
                                                        if (args.length == 2)
                                                                      @queue.push([args[0],args[1]])
                                                        else
                                                                      p "Usage: delete-slice slice"
                                                        end
                                          when "add-host"
                                                        if (args.length == 3)
                                                                      @queue.push([args[0],args[1],mac])
                                                        else
                                                                      p "Usage: add-host slice mac"
                                                        end
                                          when "delete-host"
                                                        if (args.length == 3)
                                                                      @queue.push([args[0],args[1],mac])
                                                        else
                                                                      p "Usage: delete-host slice mac"
                                                        end
                                          when "show"
                                                        if (args.length == 1)
 
                                                        else
                                                                      p "Usage: show"
                                                        end
                                          when "test_001"
                                                        if (args.length == 1)
                                                                      @queue.push(["test_001", 1])
                                                        else
                                                                      p "Usage: test_001"
                                                        end
                                          else
                                                        p "No such command"
                            end
              end
 
 
  def switch_ready(dpid)
    @adb[dpid] = {} unless @adb.include?(dpid)
    send_message dpid, FeaturesRequest.new
  end
 
  def features_reply(dpid, features_reply)
    features_reply.physical_ports.select(&:up?).each do |each|
      @topology.add_port each
    end
  end
 
  def switch_disconnected(dpid)
    @fdb.each_pair do |key, value|
      @fdb.delete(key) if value['dpid'] == dpid
    end
    @topology.delete_switch dpid
    @adb.delete(dpid) if @adb.include?(dpid)
  end
 
  def port_status(dpid, port_status)
    updated_port = port_status.port
    return if updated_port.local?
    @topology.update_port updated_port
  end
 
  def packet_in(dpid, packet_in)
    if packet_in.ipv4?
      add_host_by_packet_in dpid, packet_in
      learn_new_host_fdb dpid, packet_in
      dest_host = @fdb[packet_in.macda]
      dest_slice = @slice_reverse[packet_in.macda]
      source_slice = @slice_reverse[packet_in.macsa]
      if dest_slice == source_slice
        unless dest_slice.nil?
          set_flow_for_routing dpid, packet_in, dest_host if dest_host
        end
      end
    elsif packet_in.lldp?
      @topology.add_link_by dpid, packet_in
    end
  end
 
  def flow_removed(dpid, flow_removed)
    action = @adb[dpid][flow_removed.match.to_s]
    if action
      @topology.decrement_link_weight_on_flow dpid, action
      @adb[dpid].delete(flow_removed.match.to_s)
    end
  end
 
  private
 
  def learn_new_host_fdb(dpid, packet_in)
    unless @fdb.key?(packet_in.macsa)
      new_host = { 'dpid' => dpid, 'in_port' => packet_in.in_port }
      @fdb[packet_in.macsa] = new_host
    end
  end
 
  def add_host_by_packet_in(dpid, packet_in)
    unless @topology.hosts.include?(packet_in.ipv4_saddr.to_s)
      @topology.add_host packet_in.ipv4_saddr.to_s
      @topology.add_host_to_link dpid, packet_in
    end
  end
 
  def set_flow_for_routing(dpid, packet_in, dest_host)
    if dest_host['dpid'] == dpid
      flow_mod_to_host(dpid, packet_in, dest_host['in_port'], FLOWHARDTIMEOUT)
      packet_out(dpid, packet_in, dest_host['in_port'])
      key = Match.new(
        dl_src: packet_in.macsa.to_s,
        dl_dst: packet_in.macda.to_s
      ).to_s
      @adb[dpid][key] = dest_host['in_port'] unless @adb[dpid].include?(key)
    else
      sp = @command_line.shortest_path
      links_result = sp.get_shortest_path(@topology, dpid, dest_host['dpid'])
      p links_result
      if links_result.length > 0
        links_result.each do |each|
          flow_mod(each[0], packet_in, each[1].to_i, FLOWHARDTIMEOUT)
          key = Match.new(
            dl_src: packet_in.macsa.to_s,
            dl_dst: packet_in.macda.to_s
          ).to_s
          @adb[each[0]][key] = each[1] unless @adb[each[0]].include?(key)
          @topology.increment_link_weight_on_flow each[0], each[1]
        end
      end
    end
    p @adb
  end
 
  def flood_lldp_frames
    @topology.each_switch do |dpid, ports|
      send_lldp dpid, ports
    end
  end
 
  def check_queue
    slice_command_run unless @queue.empty?
  end
 
  def slice_command_run
    queue_result = @queue.pop
    p queue_result
    command = queue_result[0]
    case command
=begin
    when "create-slice"
      unless @slice[queue_result[1]]
        @slice[queue_result[1]] = []
      else
        p "Error: This slice already exists."
      end
=end
    when "create-slice"
      unless @db.slice?(queue_result[1]) # slice does not exist
        @db.create_slice(queue_result[1]) # add slice
      else
        p "Error: This slice already exists."
      end
=begin
    when "delete-slice"
      if @slice[queue_result[1]] # need to delete flow entry in switch
        @slice[queue_result[1]].each do |each|
          p each
          flow_mod_delete(each)
          @slice_reverse.delete(each)
        end
        @slice.delete(queue_result[1])
      else
        p "Error: Such a slice does not exist."
      end
=end
=begin
    when "delete-slice"
      if # slice exists
        # delete-slice
        # flow_mod_delete?
      else
        p "Error: Such a slice does not exist."
      end
=end
=begin
    when "add-host"
      if @slice[queue_result[1]]
        unless @slice[queue_result[1]].include?(queue_result[2])
          unless @slice_reverse.key?(queue_result[2])
            @slice[queue_result[1]] << queue_result[2]
            @slice_reverse[queue_result[2]] = {} if @slice_reverse[queue_result[2]].nil?
            @slice_reverse[queue_result[2]] = queue_result[1]
          else
            p "Error: This mac address already exist."
          end
        else
          p "Error: This mac address already exist."
        end
      else
        p "Error: This slice does not exist."
      end
=end
    when "add-host"
      if slice?(queue_result[1]) # slice exists
        add-host(queue_result[1], queue_result[2]) # add-host
      else
        p "Error: This slice does not exist."
      end
=begin
    when "delete-host"
      if @slice[queue_result[1]]
        if @slice[queue_result[1]].delete(queue_result[2]).nil?
          p "Error: Such a mac address does not exist."             
        end
        if @slice_reverse[queue_result[2]]
          @slice_reverse.delete(queue_result[2])
          flow_mod_delete(queue_result[2])
        else
          p "Error: Such a mac address does not exist."
        end
      else
        p "Error: Such a slice does not exist"
      end
=end
=begin
    when "delete-host"
      if # slice exists
        #delete-host
      else
        p "Error: Such a slice does not exist"
      end
=end
    when "test_001"
      mac1 = Mac.new("00:00:00:00:00:01")
      mac2 = Mac.new("00:00:00:00:00:03")
      @slice["1"] = [mac1, mac2]
      @slice_reverse[mac1] = "1"
      @slice_reverse[mac2] = "1"
    else
      p "cannot read command"
    end
    p @slice
    p @slice_reverse
  end
 
  def send_lldp(dpid, ports)
    ports.each do |each|
      port_number = each.number
      send_packet_out(
        dpid,
        actions: SendOutPort.new(port_number),
        data: lldp_binary_string(dpid, port_number)
      )
    end
  end
 
  def lldp_binary_string(dpid, port_number)
    destination_mac = @command_line.destination_mac
    if destination_mac
      Pio::Lldp.new(dpid: dpid,
                    port_number: port_number,
                    destination_mac: destination_mac.value).to_binary
    else
      Pio::Lldp.new(dpid: dpid, port_number: port_number).to_binary
    end
  end
 
  def flow_mod(dpid, message, port, timeout)
    send_flow_mod_add(
      dpid,
      hard_timeout: timeout,
      match: Match.new(dl_src: message.macsa.to_s, dl_dst: message.macda.to_s),
      actions: SendOutPort.new(port)
    )
  end
 
  def flow_mod_to_host(dpid, message, port, timeout)
    send_flow_mod_add(
      dpid,
      hard_timeout: timeout,
      match: Match.new(dl_dst: message.macda.to_s),
      actions: SendOutPort.new(port)
    )
  end
 
  def flow_mod_delete(dst_mac)
    @adb.each do |key, value|
      send_flow_mod_delete(
        key,
        match: Match.new(dl_dst: dst_mac.to_s)
      )
      send_flow_mod_delete(
        key,
        match: Match.new(dl_src: dst_mac.to_s)
      )
    end
  end
 
  def packet_out(dpid, message, port)
    send_packet_out(
      dpid,
      packet_in: message,
      actions: SendOutPort.new(port)
    )
  end
end
 
### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
