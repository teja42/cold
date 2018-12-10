module Cold
   class Handler
      include HTTP::Handler
      
      def call(context : HTTP::Server::Context)
         context.response.content_type = "text/html"
         context.response.puts "Sup?"
      end

   end
end