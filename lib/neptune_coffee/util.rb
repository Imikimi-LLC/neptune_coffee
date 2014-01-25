module NeptuneCoffee

  class Util
    class << self
      # returns a hash of path's subdirectories mapped to recursive calls on subdir_hash on those subdirs
      def subdir_hash path
        result = {}
        path.children.each do |c|
          result[c] = subdir_hash c if c.directory?
        end
        result
      end

      # returns number of hash and array elements recursively
      def deep_length data
        case data
        when Hash  then data.length + data.inject(0) {|sum,v| sum + deep_length(v[1])}
        when Array then data.length + data.inject(0) {|sum,v| sum + deep_length(v)}
        else 0
        end
      end
    end
  end
end
