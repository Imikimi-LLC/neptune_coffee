module NeptuneCoffee

  class SimpleDirectoryStructure
    attr_accessor :directories, :root
    def initialize root
      @root = Pathname.new root
      @directories={@root => []}
    end

    def length; @directories.length; end

    def valid_path path
      path = case path
      when Pathname then path
      when String then Pathname.new path
      else raise "invalid path object type: #{path.class}"
      end
      raise "path #{path.to_s.inspect} has not been added" unless @directories[path]
      path
    end

    def add path, subdir
      path = valid_path path
      subdir_path = path + subdir
      @directories[subdir_path] = []
      @directories[path] << subdir_path
      subdir_path
    end

    def all
      @directories.keys
    end

    def subdirs path = @root
      @directories[valid_path(path)]
    end

    def add_all path = @root
      valid_path(path).children.each do |c|
        next unless c.directory?
        add path, c.basename
        add_all c
      end
    end
  end
end
