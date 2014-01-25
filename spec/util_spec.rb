require 'pathname'
require Pathname.new(__FILE__).dirname + "../lib/neptune_coffee"

module NeptuneCoffee
describe Util do

  it "subdir_hash" do
    root = Pathname.new(__FILE__).dirname + "../examples/before"
    a = Util.subdir_hash root

    geometry = root + "geometry"
    solids = geometry + "solids"
    b = {geometry => {solids => {}}}

    a.should == b
  end

  it "deep_length number" do
    Util.deep_length(1).should == 0
  end

  it "deep_length string" do
    Util.deep_length("foo").should == 0
  end

  it "deep_length array" do
    Util.deep_length([1,2,3]).should == 3
  end

  it "deep_length hash" do
    Util.deep_length({a:1, b:2}).should == 2
  end

  it "deep_length everything" do
    Util.deep_length([1,"foo",3,[4,5,6,7],{a:1, b:[4,5]}]).should == 13
  end

end
end
