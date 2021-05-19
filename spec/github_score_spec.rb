# frozen_string_literal: true

require 'rspec'
require_relative '../lib/github_score'
require_relative '../lib/event_fetcher'

RSpec.describe GithubScore do
  let(:github_score) { GithubScore.new('test_handle') }
  let(:events) do
    [
      { type: 'PushEvent' },
      { type: 'IssuesEvent' }
    ]
  end

  describe '#score' do
    let(:event_fetcher) { instance_double(EventFetcher, get: events) }

    before { allow(EventFetcher).to receive(:new) { event_fetcher } }

    context 'when the event list is empty' do
      let(:events) { [] }

      it 'returns score 0' do
        expect(github_score.compute).to eq 0
      end
    end

    context 'when the event list is not empty' do
      it 'returns computed score' do
        expect(github_score.compute).to eq 4
      end
    end

    context 'for invalid handle' do
      before { allow(event_fetcher).to receive(:get).and_raise(EventFetcher::Error) }

      it 'raises error from event fetcher' do
        expect { github_score.compute }.to raise_error(EventFetcher::Error)
      end
    end
  end
end
