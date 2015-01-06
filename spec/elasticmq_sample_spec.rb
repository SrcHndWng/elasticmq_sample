require 'spec_helper'
require 'aws-sdk-core'

describe ElasticmqSample do
  it 'has a version number' do
    expect(ElasticmqSample::VERSION).not_to be nil
  end

  QUEUE_NAME = 'elasticmq_sample_queue'
  MESSAGE = 'test message.'

  let(:sqs_sample) { ElasticmqSample::SqsSample.new }
  let(:client) {
    Aws::SQS::Client.new({
      region: 'us-west-2',
      endpoint: 'http://localhost:9324',
      profile: 'personal'
    })
  }

  describe 'queue create and delete' do
    queue = nil
    receipt_handle = ''

    # If you comment out this before method, you can use Amazon SQS, not ElasticMQ on local.
    before(:each) do
      allow(sqs_sample).to receive(:client).and_return(client)
    end

    it 'create queue' do
      queue = sqs_sample.create_queue(QUEUE_NAME)
      expect(queue[:queue_url].include?(QUEUE_NAME)).to eq(true)
    end

    it 'send message' do
      result = sqs_sample.send_message(queue[:queue_url], MESSAGE)
      expect(result[:message_id]).not_to eq(nil?)
    end

    it 'receive message' do
      result = sqs_sample.receive_message(queue[:queue_url])
      receipt_handle = result.messages[0][:receipt_handle]
      count = result.messages.count
      expect(count).not_to eq(0)
    end

    it 'delete message' do
      result = sqs_sample.delete_message(queue[:queue_url], receipt_handle)
      expect(result.nil?).to eq(false)
    end

    it 'delete queue' do
      result = sqs_sample.delete_queue(queue[:queue_url])
      expect(result.nil?).to eq(false)
    end

  end
end
