require 'pathname'
require 'fileutils'
require 'tmpdir'
require Pathname.new(__FILE__).dirname + "../lib/neptune_coffee"

module NeptuneCoffee
describe Generator do

  it "deep_length number" do
    before_example_path = Pathname.new(__FILE__).dirname + "../examples/before/geometry"
    before_example_path.directory?.should == true

    after_example_path = Pathname.new(__FILE__).dirname + "../examples/after/geometry"
    after_example_path.directory?.should == true

    dir = Dir.mktmpdir do |dir|
      path = Pathname.new dir
      FileUtils.cp_r before_example_path.to_s, dir

      generator = NeptuneCoffee::Generator.new root:path, quiet:true
      generator.generate_all

      # puts `find #{dir}` # list all files in temp dir
      `diff -ru #{after_example_path.dirname} #{path}`.should == ""
    end
  end

end
end
