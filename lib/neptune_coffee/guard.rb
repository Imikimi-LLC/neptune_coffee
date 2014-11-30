require 'guard'

module ::Guard
  module UI
    class << self
      # add "success" to extend "warning", "error" and "info"
      # "success" is like "info" except it is green to stand out
      def success(message, options = {})
          _filtered_logger_message(message, :info, :green, options)
      end
    end
  end
end
