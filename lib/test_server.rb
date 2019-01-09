require "test_server/version"
require 'socket'

module TestServer
  class << self
    def run!(options)
      case options[:mode]
      when :serve
        serve!(options)
      when :push
        test(options)
      end
    end

    def test(options)
      with_client(options) do |client|
        client.sendmsg options[:files].join(' ')
      end
    end

    def serve!(options)
      with_server(options) do |server|
        puts "Initializing TestServer with pid #{$$}..."
        require 'test_helper'
        puts "Ready!"
        loop do
          conn = server.accept
          files, _ = conn.recvmsg
          pid = fork do
            puts "> Testing files: #{files}"
            if files == ":all".freeze
              all_glob = ENV['ALL_GLOB'] || 'test/**/*_test.rb'
              Dir.glob(all_glob).each { |f| load f }
            else
              files.split(' ').each { |f| load f }
            end
          end
          _, status = Process.wait2(pid)
          if status.exitstatus == 0
            notify("Tests passed :)") if options[:notify_on_pass]
          else
            notify("Warning! Tests failed :(") if options[:notify_on_fail]
          end
        end
      end
    end

    def with_client(options)
      if options[:remote]
        yield TCPSocket.new(options[:host], options[:port])
      else
        yield UNIXSocket.new(options[:sock])
      end
    end

    def with_server(options)
      if options[:remote]
        yield TCPServer.new(options[:host], options[:port])
      else
        begin
          `rm #{options[:sock]}` if File.exist?(options[:sock])
          yield UNIXServer.new(options[:sock])
        ensure
          `rm #{options[:sock]}` if File.exist?(options[:sock])
        end
      end
    end

    def notify(msg)
      require 'terminal-notifier'
      TerminalNotifier.notify(msg)
    end
  end
end
