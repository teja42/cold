require "./src/main.cr"

cold = Cold::Server.new
cold.listen 3000