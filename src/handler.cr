require "./facade.cr"

module Cold
   class Handler
      include HTTP::Handler

      private @n : Int16 # Because I don't think there will be more than 65_536 middlewares in a single app
      private @routeInfo : Hash(String,Hash(String, NamedTuple(route: Proc(Cold::Facade,Nil),mw: Array(Int16) )))
      private @middleware : Hash(String, Hash(String, Int16))
      private @middlewareHandler = [] of Proc(Cold::Facade, Proc(Nil,Nil), Nil)

      def initialize
         @n = 0
         @routeInfo = {} of String => Hash(String, NamedTuple(route: Proc(Cold::Facade,Nil),mw: Array(Int16)))
         @middleware = {} of String => Hash(String, Int16)
         @middlewareHandler = [] of Proc(Cold::Facade, Proc(Nil,Nil), Nil)
      end

      private def pathCheck(path : String -> Int8)
         if path=="/"
            return 0
         elsif !path.starts_with?("/") || path.ends_with?("/")
            raise "Error : `#{path}` is not a valid path name. It should start with / and should NOT end with /"
            return -1
         else 
            return 0
         end
      end

      def addRoute(method : String, path : String,p : Proc(Cold::Facade,Nil))

         if pathCheck(path)!=0
            return
         end

         begin
            @routeInfo[method]
         rescue
            @routeInfo[method] = {} of String => NamedTuple(route: Proc(Cold::Facade,Nil),mw: Array(Int16))
         ensure
            @routeInfo[method][path] = {
               route: p,
               mw: [] of Int16
            }
         end
      end

      def addMiddleware(method : String, path : String, p : Proc(Cold::Facade, Proc(Nil,Nil) ,Nil) )

         if pathCheck(path)!=0
            return
         end

         begin
            @middleware[method]
         rescue
            @middleware[method] = {} of String => Int16
         ensure
            @middlewareHandler << p
            @middleware[method][path] = @n
            @n+=1
         end
      end

      def call(context : HTTP::Server::Context)

         # Try to access the procs from @routeInfo. If any exceptions are raised then the 
         # reason is because it doesn't exist and that means it's a 404
         begin 
            @routeInfo[context.request.method][context.request.resource]
         rescue ex
            context.response.content_type = "text/plain"
            context.response.status_code = 404
            context.response.puts "Not Found"
            return
         end

         # Run middlewares if any

         # PrettyPrint.format(@middleware,STDOUT,80,"\n",4);

         # Obtain the route and execute it
         route = @routeInfo[context.request.method][context.request.resource][:route]
         begin
            route.call(Cold::Facade.new(context))
         rescue ex
            puts "Warning : Exception raised while trying to reply to : #{context.request.method} #{context.request.path}. Check log for more info"

            begin # Because if the headers have already been sent then respond_with_error call would cause an error
               context.response.respond_with_error
            rescue ex
            end

         end

      end

      def bind_middlewares
      end

   end
end