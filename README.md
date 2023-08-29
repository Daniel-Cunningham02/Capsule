---
title: Zig Package Manager timeline
created: '2023-08-29T13:09:59.862Z'
modified: '2023-08-29T14:25:01.631Z'
---

# Zig Package Manager timeline

I have had the name for a while. I have been thinking about calling it Capsule. I think it would match with the space theme that Zig has.

## Specifications Checklist in order of priority
- [ ] Server Organization
- [ ] CLI Organization and use
- [ ] Responsive website that shows the packages that are published

## Server Organization
The server should be able to receive file data to be published. It will then be placed into its own directory where it will be processed. A release directory will be made in which a .lib and .dll files exist.

After compiling the .lib and .dll files, both will be available for download along with the source files. When the server receives a GET /lib?=:package request with :package being a package published through this, the server will send the static library file. Likewise when the server receives a GET /dll?=:package, the server will send the dynamic library file. There will be other endpoints as well.

### API Endpoints to be accessed through CLI
* GET /lib?=:package - for getting .lib files
* GET /dll?=:package - for getting .dll files
* GET /src?=:package - for getting source files
* PUT /packages?=:package - for publishing packages

## CLI Organization and use
A good CLI application is modular and easy to use. Therefore, I would follow the same format as earlier package managers. This includes flags and ease-of-use from the command like. A way of invoking the package manager would be:\
\
`Capsule <command> <flag> <options of the flag> <options of the command>`

\
Commands that I know will have to be implemented:
* `Capsule get <package>` - will send a get request to the REST API for source file(s). This would also set up the project to use Capsule by modifying the build file of Zig.
* `Capsule get -l <package>` - will send a get request to the REST API for .lib file
* `Capsule get -d <package>` - will send a get request to the REST API for .dll file
* `Capsule publish <package>` - will go through setup and send POST request to the REST API
* `Capsule help` - Will print commands and their descriptions
* `Capsule help <command>` - will print the in-depth descriptions of a command
This is what I can think of right now. There might be more utility to add later; however, this is what I can think of right now.

## Responsive website
I would like to add a place to upload documentation to. I would like it to be a website similar to [Go's package web](pkg.go.dev). This is the least of my priorities because zig is a developing language and the actual tool of a package manager, which has not been released, would help more than a documentation website. A package manager has been built, but it has limitations, [Zap, Zig's official package manager](https://zig.news/edyu/zig-package-manager-wtf-is-zon-558e). Programmers can include markdown or html files of documentation in the source files themselves, and I might include a way to download the documentation separately.

## Timeline
Because there are three monolithic parts of this project and because I only have two semesters for programming and one for a writeup and presentation, I would like to finish the REST API and CLI this semester (Fall 2023). Then, I would like to refine the REST API and CLI and develop the website in the spring. There is a bit of room to be flexible. If the CLI, which will be second, runs into the spring semester, I will push back the website a bit. I highly doubt that the REST API will take as long as the other parts because I have experience with REST APIs. I recently have been creating a REST API in go with gin gonic, and I plan to use the same library for the server-side.

## Tentative Timeline maybe?
* 3rd week of September: Have the GET requests working as needed along with a database for associating the name of a package and its directory on the server. Begin working on CLI.
* 3rd week of October: Have the GET requests finished. Begin closely developing both the publish PUT request and the CLI part, so they are "seamless."
* End of the semester (right before finals): Have a working demo of the Server and CLI interacting. Try to have it "seamless" and working properly.
* Over Christmas Break: Refine the server and maintain the CLI with Zig's updates.
* 1st week of February: Have a basic but usable version of the website. Begin working on making the website faster and more appealing.
* February through the end of the semester: This will be the extra time. This will be used for whatever needs to be done such as maintaining and fixing bugs.
* Sometime in the spring or summer: Host the server and publish the CLI for public use.
\
This timeline is quite compact. While I think it is possible, there will most likely be events and tragedies (tests) that get in the way. However, I would rather the timeline be compact and give extra time to be flexible than be to lenient with my time.

\
\
As for technologies/languages:
* Server-side: go and gin-gonic, and Zig to compile the files to .lib and .dll
* CLI: Zig and C (Because Zig has amazing interoperability with C)
* Website: HTML and Javascript
