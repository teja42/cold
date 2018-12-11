module Cold
   class Facade

      property context : HTTP::Server::Context

      def initialize(c : HTTP::Server::Context)
         @context = c
      end

      def sendJSON(s : String)
      end

      def setStatus(s : Int32)
      end

      def send(s : String)
         @context.response.content_type = "text/html"
         @context.response.puts s
      end

      def setContentType(s : String)
      end

      def setCookie(key : String, value : String)
      end

      def getCookie(key : String)
      end

      def removeCookie(key : String)
      end

      def setResponseHeader(header : String)
      end

   end
end