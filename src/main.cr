# native modules
require "http/server"

# custom modules
require "./handler.cr"

module Cold

   class Server

      @port : Int32
      @handler : Cold::Handler 
      # @handler is responsible for handling the incomming requests

      def initialize
         @port = 80
         @handler = Cold::Handler.new
      end

      def listen(port : Int32)
         if port < 0 || port > 65_535
            puts "Warning : Invalid port. Using 80"
         else
            @port = port
         end

         if @handler.bind_middlewares !=0
            return
         end

         server = HTTP::Server.new([
            @handler
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

      def on(method : String , path : String , &block : Cold::Facade -> Nil)
         method = method.to_s.upcase
         @handler.addRoute(method,path,block)
      end

      def use(method : String, path : String, &block : Cold::Facade, Proc(Nil,Nil) -> Nil)
         @handler.addMiddleware(method,path,block)
      end

      def use(path : String, &block : Cold::Facade, Proc(Nil,Nil) -> Nil)
         @handler.addMiddleware("all",path,block)
      end

   end

end