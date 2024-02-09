# Capsule
Capsule - Alternative Zig package manager

## Plan
As of now, I am behind my current plan. I am working on catching up.\\
The README will be updated to reflect software improvements and developments
### Server
- [X] Basic server software setup
- [ ] Basic server security(TLS) is in place
- [X] Server can send files to a socket
- [X] Server can send directories to a socket
- [ ] Server can accept a source folder to be uploaded
- [ ] Server contains a database which contains information to only allow certain users to update a package
### CLI
- [X] Basic CLI interface is in place
- [X] CLI is able to use the `get` command to receive and download .dll and .libs
- [X] CLI is able to use the `get` command to receive and download source packages
- [ ] CLI flags work properly and allow for dynamic use of commands
- [ ] CLI may publish packages to the server and receive the correct message depending on the success of the operation
- [ ] CLI has some implementation of a developer portal to decouple the user from the developer. This allows for a more strenuous, robust security system.
### Website
The Website is my last priority. I'm going to try to focus on what is said above. My requirements for the website will be added later.