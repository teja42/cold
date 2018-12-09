require "http/server"

class Cold

   @port : Int32

   # @routeInfo
   # routeInfo is a named tuple
   # contains proc to execute on a specific route

   def initialize
      @port = 80
   end

   def listen(port : Int32)
      if port < 0 || port > 65_535
         puts "Warning : Invalid port. Using 80"
      else
         @port = port
      end

      server = HTTP::Server.new do |context|
         context.response.content_type = "application/json"
         context.response.print "{a:2}"
         # PrettyPrint.format(context.request,STDOUT,80,"\n",3)
         puts context.request.path
      end

      begin
         server.bind_tcp @port
      rescue ex
         puts "Error : Failed to bind to port #{@port}. Reason {\n\t#{ex.message}\n}"
      else
         puts "Listening on port #{@port}"
         server.listen
      end

   end

   # def on(method : String , path : String , &block : )
   #    @routeInfo[method][path] = cb
   # end

end