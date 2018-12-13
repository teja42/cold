require "./src/main.cr"

cold = Cold::Server.new

cold.on "get", "/hey" { |f|
   f.send("hey there");
}

cold.use "get", "/" { |f,next|
   f.send("I'm a middleware for GET /")
}

cold.use "get", "/hey" {|f,next|
   f.send("I'm a middleware for GET /hey")
}

cold.on "get", "/" {|f|
   f.send "Hello world!"
}

cold.on "post", "/" {|f|
   f.send "Hello to post!"
}

cold.listen 3000