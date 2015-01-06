require "elasticmq_sample/version"
require 'aws-sdk-core'
require 'aws-sdk-core/sqs_queue_urls'

module ElasticmqSample
  class SqsSample
    def create_queue(queue_name)
      queue = client.create_queue(
        queue_name: queue_name,
      )
    end

    def send_message(queue_url, body)
      client.send_message(
        queue_url: queue_url,
        message_body: body
      )
    end

    def receive_message(queue_url)
      client.receive_message(
        queue_url: queue_url
      )
    end

    def delete_message(queue_url, receipt_handle)
      client.delete_message(
        queue_url: queue_url,
        receipt_handle: receipt_handle,
      )
    end

    def delete_queue(queue_url)
      client.delete_queue(
        queue_url: queue_url
      )
    end

    private

    def client
      @client ||= Aws::SQS::Client.new(
        region: 'us-west-2',
        profile: 'personal'
      )
    end
  end
end
