require "pathname"
%w{
  version
  util
  guard
  generator
  javascript_generator
  simple_directory_structure
}.each do |mod|
  require Pathname.new(__FILE__).dirname + "neptune_coffee" + mod
end
