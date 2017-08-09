#!/usr/bin/env ruby

# A small helper script that reads 'ebml_matroska.xml' and all header
# files from an existing libMatroska source directory, iterates over
# all elements given in 'ebml_matroska.xml' and verifies that the
# class name specified by either the 'cppname' or (in its absence) the
# 'name' attribute actually exists.

require "rexml/document"
require "trollop"

def parse_opts
  opts = Trollop::options do
    opt :xml,     "Path to the ebml_matroska.xml spec file",                                 :type => String, :default => './ebml_matroska.xml'
    opt :headers, "Path to the 'matroska' directory containing libmatroska's include files", :type => String, :default => './matroska'
  end

  Trollop::die :xml,     "must be given and the file named by it exist"      if !opts[:xml]     || !File.exist?(opts[:xml])     || !File.file?(opts[:xml])
  Trollop::die :headers, "must be given and the directory named by it exist" if !opts[:headers] || !File.exist?(opts[:headers]) || !File.directory?(opts[:headers])

  opts
end

def read_spec file_name
  REXML::Document.new(File.new(file_name))
end

def read_headers dir_name
  Dir.entries(dir_name).
    select { |dir|  %r{\.h$}.match(dir) }.
    map    { |file| IO.readlines("#{dir_name}/#{file}").join(' ') }.
    join(' ')
end

def main
  opts    = parse_opts
  spec    = read_spec(opts[:xml])
  headers = read_headers(opts[:headers])

  REXML::XPath.each(spec, "/EBMLSchema/element") do |el|
    name     = el.attributes["name"]
    cpp_name = "Kax" + (el.attributes["cppname"] || name)

    next if %r{^EBML}.match(name)
    next if %r{\b#{cpp_name}\b}.match(headers)

    puts "Error: element '#{name}' with C++ name '#{cpp_name}' does not exist any of the include files in '#{opts[:headers]}'"
  end
end

main
