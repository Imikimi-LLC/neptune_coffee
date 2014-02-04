require 'pathname'
require Pathname.new(__FILE__).dirname + "../lib/neptune_coffee"

class Pathname
  class <<self
    def [](str)
      Pathname.new str
    end
  end
end

module NeptuneCoffee
describe JavascriptGenerator do

  it "module_js" do
    module_js = JavascriptGenerator.new(Pathname["foo"], Pathname["foo/bar"]).module [
      Pathname["foo/bar/subdir1"],
      Pathname["foo/bar/subdir2"]
    ], [
      Pathname["foo/bar/file1"],
      Pathname["foo/bar/file2"]
    ]

    module_js.should == <<ENDJS
define([
  './bar/namespace',
  './bar/file1',
  './bar/file2',
  './bar/subdir1',
  './bar/subdir2'
], function(Bar, File1, File2) {
  if (typeof File1 == 'function') {Bar.File1 = File1; File1.namespace = Bar;}
  if (typeof File2 == 'function') {Bar.File2 = File2; File2.namespace = Bar;}
  return Bar;
});
ENDJS
  end

  it "namespace_js" do
    namespace_js = JavascriptGenerator.new(Pathname["foo"], Pathname["foo/bar"]).namespace [
      Pathname["foo/bar/sub_dir1"], Pathname["foo/bar/sub_dir2"]
    ]
    namespace_js.should == <<ENDJS
define([
  './sub_dir1/namespace',
  './sub_dir2/namespace'
], function(SubDir1, SubDir2) {
  Bar = (function() {
    function Bar() {}
    return Bar;
  })();
  Bar.SubDir1 = SubDir1; SubDir1.namespace = Bar;
  Bar.SubDir2 = SubDir2; SubDir2.namespace = Bar;
  return Bar;
});
ENDJS
  end

  it "namespace_js with no subdirs" do
    namespace_js = JavascriptGenerator.new(Pathname["foo"], Pathname["foo/bar"]).namespace []
    namespace_js.should == <<ENDJS
define([], function() {
  Bar = (function() {
    function Bar() {}
    return Bar;
  })();
  return Bar;
});
ENDJS
  end

end
end
