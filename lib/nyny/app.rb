require 'nyny/base'
require 'nyny/templates'
require 'better_errors'
require 'ostruct'

module NYNY
  class App < Base
    inheritable :config, OpenStruct.new
    register NYNY::Templates

    class << self
      def configure *envs, &block
        if envs.map(&:to_sym).include?(NYNY.env.to_sym) or envs.empty?
          instance_eval(&block)
        end
      end

      def run! port=9292
        use Rack::CommonLogger
        use BetterErrors::Middleware unless NYNY.env.production?
        Rack::Handler.pick(['puma', 'thin', 'webrick']).run new, :Port => port
      end
    end
  end
end
