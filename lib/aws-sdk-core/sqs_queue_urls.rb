module Aws
  module Plugins
    # @api private
    class SQSQueueUrls < Seahorse::Client::Plugin

      class Handler < Seahorse::Client::Handler

        def update_region(context, url)
          if region = url.to_s.split('.')[1]
            context.config = context.config.dup
            context.config.region = region
            context.config.sigv4_region = region
          elsif url.include?('localhost')
            return
          else
            raise ArgumentError, "invalid queue url `#{url}'"
          end
        end

      end

    end
  end
end
