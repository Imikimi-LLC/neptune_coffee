module NeptuneCoffee
  class JavascriptGenerator
    attr_accessor :root, :dir
    def initialize root, dir
      @root = root
      @dir = dir
    end

    def define_js files, relative_to_path
      files_js = files.length == 0 ? "" : files.map{|f| "\n  './#{f.relative_path_from(relative_to_path)}'"}.join(",") + "\n"
      "define([#{files_js}], function"
    end

    def module sub_modules, class_files
      # subfiles ||= dir.children.select{|c| !c.directory? && c.extname == ".js"}
      class_files = class_files.map{|f|f.sub_ext("")}.select {|c|c.basename.to_s!="namespace"}.sort.uniq
      files = [dir + "namespace"] + class_files + sub_modules.sort.uniq

      file_class_names = class_files.map {|files| files.basename.to_s.camel_case}

      <<-ENDJS
#{define_js files, dir.dirname}(#{([namespace_name]+file_class_names).join ', '}) {#{
  file_class_names.map do |fcn|
    "\n  if (typeof #{fcn} == 'function' && !#{fcn}.namespace) {#{namespace_name}.#{fcn} = #{fcn}; #{fcn}.namespace = #{namespace_name};}"
  end.join
  }
  return #{namespace_name};
});
ENDJS
    end

    def namespace_name
      @namespace_name ||= (dir == root ? "Neptune" : dir.basename.to_s.camel_case)
    end

    def namespace subdirs
      sub_namespace_files = subdirs.map {|subdirs| subdirs + "namespace"}

      sub_namespaces = subdirs.map {|files| files.basename.to_s.camel_case}

      <<-ENDJS
#{define_js sub_namespace_files, dir}(#{sub_namespaces.join ', '}) {
  #{namespace_name} = (function() {
    function #{namespace_name}() {}
    return #{namespace_name};
  })();#{
  sub_namespaces.map do |sns|
    "\n  #{namespace_name}.#{sns} = #{sns}; #{sns}.namespace = #{namespace_name};"
  end.join
  }
  return #{namespace_name};
});
ENDJS
    end
  end
end

