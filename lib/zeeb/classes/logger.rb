require 'logger'

module Zeeb
  class Log
    include Register_Self
    register_component :log

    class << self
      attr_accessor :logger,:file 
       
      def set_level(level)
        self.logger.level = Logger.const_get level.upcase
      end

      def display(message, level)
        puts message unless level == :fatal
      end

      def []=(level,message)
        case message.class.to_s
          when 'String'
            display message, level
            self.logger.send level, message
          when 'Array'
            message.each do |line|
              display line, level
              self.logger.send level, line
            end
          when 'Hash'
            message.each do |level,line|
              display line, level
              self.logger.send level, line
            end
        else
          raise TypeError, "method expects Hash,String or Array, message was of type #{message.class}"
        end
      end
      
      def create name,file
        self.file = File.open(file, 'a')
        self.file.sync = true
        self.logger = Logger.new(self.file).tap do |log|
          log.progname = name
        end
      end

    end
   

  end

end
