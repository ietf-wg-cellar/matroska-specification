#!/usr/bin/env ruby

# A small helper script that reads 'ebml_matroska.xml' & applies
# several verification steps on element IDs.

require "rexml/document"
require "optimist"

def parse_opts
  opts = Optimist::options do
    opt :xml, "Path to the ebml_matroska.xml spec file", :type => String, :default => './ebml_matroska.xml'
  end

  Optimist::die :xml, "must be given and the file named by it exist" if !opts[:xml] || !File.exist?(opts[:xml]) || !File.file?(opts[:xml])

  opts
end

def read_spec file_name
  REXML::Document.new(File.new(file_name))
end

def main
  opts = parse_opts
  spec = read_spec(opts[:xml])
  ok   = true
  used = {

  }

  REXML::XPath.each(spec, "/EBMLSchema/element") do |el|
    name = el.attributes["name"]
    id   = el.attributes["id"].downcase

    if id.nil?
      puts "Error: #{name}: is missing the 'id' attribute"
      ok = false
      next
    end

    if !%r{^0x([0-9a-f]{2})+$}.match(id)
      puts "Error: #{name} (#{id}): the ID is not a valid hexadecimal number prefixed with '0x'"
      ok = false
      next
    end

    num          = id[2].hex
    mask         = 1 << 3
    expected_len = 1

    while (num & mask) == 0 do
      mask        >>= 1
      expected_len += 1
    end

    actual_len = (id.length - 2) / 2

    if expected_len != actual_len
      puts "Error: #{name} (#{id}): expected length #{expected_len} does not match actual length #{actual_len}"
      ok = false
      next
    end

    if used[id]
      puts "Error: #{name} (#{id}): ID is already used for #{used[id]}"
      ok = false
      next
    end

    used[id] = name
  end

  exit 1 if !ok

  puts "All element IDs are OK."
  exit 0
end

main
