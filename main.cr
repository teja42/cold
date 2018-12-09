require "http/server"

class Cold

   property port : Int32

   @routeInfo = Hash{
      "get" : Hash{},
      "post" : Hash{} 
   }

   def initialize(port : Int32)
      if port < 0
         puts "Warning : Invalid port"
         return
      end
      @port = port 
      # @server
      # path is a string to a JSON config file
   end

   def listen
      server = HTTP::Server.new do |context|
         context.response.content_type = "application/json"
         context.response.print "{a:2}"
         # PrettyPrint.format(context.request,STDOUT,80,"\n",3)
         puts context.request.resource
      end
      server.bind_tcp @port
      puts "Listening on port #{@port}"
      server.listen
   end

   def on(method : String , path : String , cb : proc)
      @routeInfo[:method][:path] = cb
   end

end