require 'extlib' # for camel_case
require "coderay"
require "pathname"

module NeptuneCoffee

  class Generator
    attr_accessor :generated_files, :to_generate_files, :current_files, :skipped_files
    attr_accessor :dirs, :force, :verbose, :quiet, :overwrite
    attr_reader :root

    SAFE_GENERATE_FIRST_LINE = "// Generated by NeptuneCoffee"

    def initialize(options)
      raise ArgumentError.new(":root option required, must be a string and valid path") unless Pathname.new(options[:root]).directory?
      @root = Pathname.new options[:root]
      @force = options[:force]
      @verbose = options[:verbose]
      @overwrite = options[:overwrite]
      @quiet = options[:quiet]
      reset_file_info
    end

    def load_dirs
      @dirs = SimpleDirectoryStructure.new @root
      @dirs.add_all
    end

    def warning(message)  Guard::UI.warning "NeptuneCoffee: "+message unless @quiet; end
    def info(message)     Guard::UI.info "NeptuneCoffee: "+message unless @quiet; end
    def success(message)  Guard::UI.success "NeptuneCoffee: "+message unless @quiet; end
    def error(message)    Guard::UI.error "NeptuneCoffee: "+message; end

    def reset_file_info
      @generated_files = {}
      @to_generate_files = {}
      @current_files = {}
      @skipped_files = {}
    end

    # returns:
    #   {
    #     current_files:    [Pathnames...]
    #     generated_files:  [Pathnames...]
    #     skipped_files:    [Pathnames...]
    #   }

    def generate_all
      reset_file_info
      load_dirs
      success "generating all files in: #{root}"
      success "#{@dirs.length} directories found"

      @dirs.all.each do |dir|
        generate_module dir unless dir == root
        generate_namespace dir
      end

      success "#{@current_files.length}/#{@to_generate_files.length} files current"
      success "#{@generated_files.length} files generated" # if @generated_files.length > 0
      warning "#{@skipped_files.length} files skipped (this is a name conflict. We recommend renaming your source file(s)." if @skipped_files.length> 0
      return {
        current_files: @current_files.keys,
        generated_files: @generated_files.keys,
        skipped_files: @skipped_files.keys
      }
    end

    def file_was_generated_by_neptune_coffee file
      !file.exist? || (file.read(SAFE_GENERATE_FIRST_LINE.length) == SAFE_GENERATE_FIRST_LINE)
    end

    def show_generated contents
      highlighted = CodeRay.scan(new_contents, :javascript).terminal
      info "output:\n    "+highlighted.gsub("\n","\n    ")
    end

    # writes to "file" whatever the block yields IF
    #   the file was originally generated by NeptuneCoffee (unless @overwrite)
    #   the file contents changed (unless @force)
    def safe_generate file
      @to_generate_files[file] = true
      info_file = file #join @root, file.split(@root)[-1]
      if @overwrite || file_was_generated_by_neptune_coffee(file)

        new_contents = SAFE_GENERATE_FIRST_LINE + " #{NeptuneCoffee::VERSION}\n" +
        "// path: #{file.relative_path_from @root}\n" + yield

        if @force || !file.exist? || file.read != new_contents
          @generated_files[file] = true
          success "generating: #{info_file}"
          show_generated new_contents if @verbose
          file.open("w") {|f| f.write new_contents}
        else
          @current_files[file] = true
        end
      else
        @skipped_files[file] = true
        warning "skipping:   #{info_file}"
      end
    end

    def generate_module dir
      subdirs = @dirs.subdirs(dir)
      files = dir.children.select {|f| f.extname.downcase == ".js" && !subdirs.index(f.sub_ext(""))}
      safe_generate(dir.sub_ext(".js"))   {JavascriptGenerator.new(root, dir).module(@dirs.subdirs(dir), files)}
    end

    def generate_namespace dir
      safe_generate(dir + "namespace.js") {JavascriptGenerator.new(root, dir).namespace(@dirs.subdirs(dir))}
    end

  end
end
