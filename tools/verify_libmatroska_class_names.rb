#!/usr/bin/env ruby

# A small helper script that reads 'ebml_matroska.xml' and all header
# files from an existing libMatroska source directory, iterates over
# all elements given in 'ebml_matroska.xml' and verifies that the
# class name specified by either the 'cppname' or (in its absence) the
# 'name' attribute actually exists.

# Additionally it verifies that the element IDs actually exist and are
# used for the expected classes in the source code.

require "rexml/document"
require "trollop"

def parse_opts
  opts = Trollop::options do
    opt :xml, "Path to the ebml_matroska.xml spec file", :type => String, :default => './ebml_matroska.xml'
    opt :lib, "Path to the libmatroska source code",     :type => String, :default => './libmatroska'
  end

  Trollop::die :xml, "must be given and the file named by it exist"      if !opts[:xml] || !File.exist?(opts[:xml]) || !File.file?(opts[:xml])
  Trollop::die :lib, "must be given and the directory named by it exist" if !opts[:lib] || !File.exist?(opts[:lib]) || !File.directory?(opts[:lib])

  opts
end

def read_spec file_name
  REXML::Document.new(File.new(file_name))
end

def read_file_content dir_name, extension
  Dir.entries(dir_name).
    map    { |file| "#{dir_name}/#{file}" }.
    select { |file| %r{\.#{extension}$}.match(file) }.
    select { |file| File.file?(file) }.
    map    { |file| IO.readlines(file).join("\n") }.
    join("\n")
end

def main
  opts    = parse_opts
  spec    = read_spec(opts[:xml])
  headers = read_file_content(opts[:lib] + "/matroska", "h")
  source  = read_file_content(opts[:lib] + "/src",      "cpp")

  REXML::XPath.each(spec, "/EBMLSchema/element") do |el|
    name     = el.attributes["name"]
    id       = el.attributes["id"]
    cpp_name = "Kax" + (el.attributes["cppname"] || name)

    next if %r{^EBML}.match(name)

    if !/\b#{cpp_name}\b/.match(headers)
      puts "Error: element '#{name}' with C++ name '#{cpp_name}' does not exist any of the include files in '#{opts[:lib]}/matroska'"
      next
    end

    if !/^DEFINE_MKX_[A-Z0-9_]+ [[:blank:]]* \( #{cpp_name} [[:blank:]]* , [[:blank:]]* ( (?i) #{id} ) [[:blank:]]* ,/sx.match(source)
      puts "Error: element '#{name}' with C++ name '#{cpp_name}' and ID '#{id}' does not exist any of the source files in '#{opts[:lib]}/src'"
    end
  end
end

main
