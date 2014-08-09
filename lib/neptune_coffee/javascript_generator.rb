require "pathname"
require "erb"

module NeptuneCoffee
  class JavascriptGenerator
    class <<self
      attr_accessor :generators
      def load_erb
        generator_root = Pathname.new(__FILE__).parent + "generators"
        @generators = {}
        generator_root.children(false).each do |erb_file|
          name = erb_file.to_s.split(/\.erb$/)[0]
          path = generator_root + erb_file
          @generators[name] = ERB.new path.read, nil, "<>-"
          @generators[name].filename = erb_file
        end
      end
    end
    JavascriptGenerator.load_erb

    attr_accessor :root, :dir, :sub_modules, :class_files, :subdirs
    def initialize root, dir
      @root = root
      @dir = dir
    end

    def files_relative_to files, relative_to_path
      files.map {|f| f.relative_path_from relative_to_path}
    end

    def define_js relative_file_paths, local_names
      files_js = if relative_file_paths.length == 0 then ""
      else
        "\n  " + relative_file_paths.map{|f| "'./#{f}'"}.join(",\n  ") + "\n"
      end

      old_buffer, @output_buffer = @output_buffer, ''
      begin
        content = yield
      ensure
        @output_buffer = old_buffer
      end

      @output_buffer << "define([#{files_js}], function(#{local_names.join ', '}) {#{content}});"
    end

    def module sub_modules, class_files
      @output_buffer = ""
      @sub_modules = sub_modules
      @class_files = class_files
      JavascriptGenerator.generators["module.js"].result(binding)
      @output_buffer
    end

    def namespace_name
      @namespace_name ||= (dir == root ? "Neptune" : dir.basename.to_s.camel_case)
    end

    def namespace subdirs
      @output_buffer = ""
      @subdirs = subdirs
      JavascriptGenerator.generators["namespace.js"].result(binding)
      @output_buffer
    end
  end
end

