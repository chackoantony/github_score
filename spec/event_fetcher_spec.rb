# frozen_string_literal: true

require 'rspec'
require 'webmock/rspec'
require_relative '../lib/event_fetcher'

RSpec.describe EventFetcher do
  let(:url) { 'https://api.github.com/users/handle/events/public' }

  let(:event_fetcher) { EventFetcher.new(url) }
  let(:response_body) do
    [
      { 'type' => 'PushEvent' },
      { 'type' => 'IssuesEvent' }
    ]
  end

  describe '#get' do
    before { stub_request(:get, url).to_return(body: response_body.to_json, status: status) }

    context 'for success response' do
      let(:status) { 200 }

      it 'returns parsed response body' do
        expect(event_fetcher.get).to eq response_body
      end
    end

    context 'for client errors' do
      let(:status) { 404 }
      let(:response_body) { { 'message' => 'error message' } }

      it 'raises error with message' do
        expect { event_fetcher.get }.to raise_error(EventFetcher::Error, response_body['message'])
      end
    end

    context 'for server errors' do
      let(:status) { 500 }
      let(:response_body) { {} }

      it 'raises error' do
        expect { event_fetcher.get }.to raise_error(EventFetcher::Error)
      end
    end
  end
end
