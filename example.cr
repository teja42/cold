require "./src/main.cr"

cold = Cold::Server.new

cold.on "get", "/hey" { |f|
   f.send("hey there");
}

cold.listen 3000