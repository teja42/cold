require "./facade.cr"

module Cold
   class Handler
      include HTTP::Handler

      @routeInfo : Hash(String,Hash(String, Array(Proc(Cold::Facade,Nil))))
      # @routeInfo(method,path,array of handlers)

      def initialize
         @routeInfo = {
            "GET" => {
               "/" => [
                  ->(f : Cold::Facade){
                     f.send "Hello world"
                  }
               ]
            }
         }
      end

      def addRoute(method : String, path : String,p : Proc(Cold::Facade,Nil))
         @routeInfo[method][path].push(p);
      end

      # def addRoute(method : String, path : String, Proc)
      
      def call(context : HTTP::Server::Context)

         # Try to access the procs from @routeInfo. If any exceptions are raised then the 
         # reason is because it doesn't exist and that means it's a 404

         begin 
            @routeInfo[context.request.method][context.request.path]
         rescue ex
            context.response.content_type = "text/plain"
            context.response.status_code = 404
            context.response.puts "Not Found"
            return
         end

         routes = @routeInfo[context.request.method][context.request.path]

         i = 0
         while i < routes.size
            begin
               routes[i].call(Cold::Facade.new(context))
            rescue ex
               puts "Warning : Exception raised while trying to reply to : #{context.request.method} #{context.request.path}. Check log for more info"

               begin # Because if the headers have already been sent then respond_with_error call would cause an error
                  context.response.respond_with_error
               rescue ex
               end

            else
               i = i+1
            end
         end

      end

   end
end