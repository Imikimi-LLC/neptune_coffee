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

    module_js.should ==
"define([
  './bar/namespace',
  './bar/file1',
  './bar/file2',
  './bar/subdir1',
  './bar/subdir2'
], function(Bar, File1, File2) {
  if (typeof File1 == 'function') {Bar.File1 = File1; File1.namespace = Bar;}
  if (typeof File2 == 'function') {Bar.File2 = File2; File2.namespace = Bar;}
  return Bar;
});"
  end

  it "namespace_js" do
    namespace_js = JavascriptGenerator.new(Pathname["foo"], Pathname["foo/bar"]).namespace [
      Pathname["foo/bar/sub_dir1"], Pathname["foo/bar/sub_dir2"]
    ]
    namespace_js.should ==
"define([], function() {
  var Bar = (function() {
    function Bar() {}
    return Bar;
  })();
  return Bar;
});"
  end

  it "namespace_js with no subdirs" do
    namespace_js = JavascriptGenerator.new(Pathname["foo"], Pathname["foo/bar"]).namespace []
    namespace_js.should ==
"define([], function() {
  var Bar = (function() {
    function Bar() {}
    return Bar;
  })();
  return Bar;
});"
  end

end
end
