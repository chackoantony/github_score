# frozen_string_literal: true

class GithubScore
  SCORING_PARAMS = {
    'IssuesEvent' => 1,
    'IssueCommentEvent' => 2,
    'PushEvent' => 3,
    'PullRequestReviewCommentEvent' => 4,
    'WatchEvent' => 5,
    'CreateEvent' => 6
  }.freeze

  def initialize(handle)
    @handle = handle
  end

  def compute
    events.sum { |event| SCORING_PARAMS[event[:type]] || 1 }
  end

  private

  attr_reader :handle

  def events
    @events ||= EventFetcher.new(url).get
  end

  def url
    @url ||= "https://api.github.com/users/#{handle}/events/public"
  end
end
