require "http/server"

require "./handler.cr"

module Cold

   class Server

      @port : Int32
      # @routeInfo : NamedTuple()

      # @routeInfo
      # routeInfo is a named tuple
      # contains proc to execute on a specific route

      def initialize
         @port = 80
         # @routeInfo = {
         #    "GET": {
         #       "/": ->(){
         #          puts "Hello, world!"
         #       }
         #    }
         # }
      end

      def listen(port : Int32)
         if port < 0 || port > 65_535
            puts "Warning : Invalid port. Using 80"
         else
            @port = port
         end

         server = HTTP::Server.new([
            Cold::Handler.new
         ])

         begin
            server.bind_tcp @port
         rescue ex
            puts "Error : Failed to bind to port #{@port}. Reason {\n\t#{ex.message}\n}"
         else
            puts "Listening on port #{@port}"
            server.listen
         end

      end

      # def on(method : String , path : String , &block : Tuple -> _)
      #    method = method.to_s.upcase
      #    @routeInfo[method][path] = block
      # end

   end

end