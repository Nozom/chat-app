const express = require("express");
const app = express();
const { createServer } = require("http");
const server = createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

const { config } = require("dotenv");
config();

const cors = require("cors");

app.use(cors());

io.on("connection", (socket) => {
  console.log(socket.id, "connected");
  socket.on("connected", (data) => {
    console.log(data);
    socket.join(data);
    socket.broadcast.emit("user-connected", data);
  });
  socket.on("message", (data) => {
    console.log(data);
    io.to(data.to).emit("message", data);
  });
  socket.on("typing", (data) => {
    console.log(data);
    io.to(data).emit("typing");
  });
  socket.on("stop-typing", (data) => {
    console.log(data);
    io.to(data).emit("stop-typing");
  });
  socket.on("message-read", (data) => {
    console.log(data);
    io.to(data).emit("message-read");
  });
  socket.on("offline", (data) => {
    console.log(data, "offline");
    socket.leave(data);
    socket.broadcast.emit("user-disconnected", data);
  });
  socket.on("disconnect", () => {
    console.log(socket.id, "disconnected");
  });
});

const port = process.env.PORT || 4000;

server.listen(port, "0.0.0.0", () => {
  console.log("Server running on port", port);
});
