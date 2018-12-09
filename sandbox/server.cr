require "http/server"

server = HTTP::Server.new(3000) do |context|
   context.response.content_type = "text/plain"
   context.response.print "Hello world!"
   puts PrettyPrint.new.format(context.request)
end