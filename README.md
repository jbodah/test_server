# test_server

dead simple fork based test server

## Description

`test_server` is a generic tool that lets you quickly build an ad-hoc Ruby workflow efficiently. It provides you with a server/client model where the client instructs the server on which files to load. The server will fork off a new child process  which load those files and then the server will listen for more instructions. The most common use case for this is for testing, but it also could be used for compiling or other tasks

## Usage

```
gem install "test_server_rb"
test_server --serve

# in another process
test_server --test test/unit/hello.rb
```
