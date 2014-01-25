require 'pathname'
require Pathname.new(__FILE__).dirname + "../lib/neptune_coffee"

module NeptuneCoffee
describe SimpleDirectoryStructure do

  it "initialize" do
    sds = SimpleDirectoryStructure.new "."
    sds.root.should == Pathname.new(".")
    sds.subdirs(sds.root).should == []
  end

  it "add subdir" do
    sds = SimpleDirectoryStructure.new "."
    sds.add ".", "foo"
    sds.add ".", "bar"
    sds.subdirs.map{|sd|sd.basename.to_s}.should == ["foo", "bar"]
    sds.subdirs("foo").map{|sd|sd.basename.to_s}.should == []
    sds.subdirs("bar").map{|sd|sd.basename.to_s}.should == []
    sds.all.map{|sd|sd.basename.to_s}.should == [".", "foo", "bar"]
  end

  it "read example_dir" do
    path = Pathname.new(__FILE__).dirname + ".." + "examples/before/"
    sds = SimpleDirectoryStructure.new path
    sds.add_all
    sds.subdirs.map{|sd|sd.basename.to_s}.should == ["geometry"]
    sds.subdirs(path+"geometry").map{|sd|sd.basename.to_s}.should == ["solids"]
    sds.subdirs(path+"geometry/solids").map{|sd|sd.basename.to_s}.should == []
    sds.all.map{|sd|sd.basename.to_s}.should == ["before", "geometry", "solids"]
  end

end
end
