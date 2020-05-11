require "rubygems"
require "gmail-britta"

EMAIL_ADDRESSES=%W{
  mike@liftoff.io
  mikeq@liftoff.io
}
GITHUB_USERNAME="mikejquinn"

DI_TEAM=[
  "Caleb Spare",
  "GaYoung Park",
  "Nicholas Feinberg",
  "Ray Wu"
]

BIDDING_TEAM=[
  "Andy Sponring",
  "Dongliang Xu",
  "Daniel MacDougall",
  "Jing Brian Zhou",
  "Ken Chen"
]

fs = GmailBritta.filterset(:me => EMAIL_ADDRESSES) do
  # Deploys
  # Our older deploys send emails whenever they are initiated. As our remaining projects
  # are ported to use Ploy, we'll send fewer of these emails.
  filter {
    has   %W{to:notifications+deploy@liftoff.io}
    label "deploys"
    archive
    mark_read
  }

  filter {
    has %W{deliveredto:dkulakhmetov@liftoff.io -from:liftoff.io}
    label "oldemployees/daniyar"
    archive
  }

  # Github Filters
  # I filter all PRs/comments from members of the DI team to their own
  # label. Any Github notifications that specifically target me are sent to my inbox
  # instead of being auto-archived.
  filter {
    has  %W{from:notifications@github.com}
    label "gh"
  }
  filter {
    has  %W{from:notifications@github.com "this pull request"}
    label "gh/pull-requests"
  }
  filter {
    names = DI_TEAM.map { |n| "from:\"#{n}\"" }.join(' ')
    has "{#{names}} from:notifications@github.com"
    label "gh/data-infra"
  }
  filter {
    names = BIDDING_TEAM.map { |n| "from:\"#{n}\"" }.join(' ')
    has "{#{names}} from:notifications@github.com"
    label "gh/bidding"
  }
  filter {
    has  %W{from:notifications@github.com cc:assigned@noreply.github.com}
    label "gh/assigned"
  }
  filter {
    has [{:or => %w{cc:mention@noreply.github.com cc:author@noreply.github.com cc:comment@noreply.github.com cc:assigned@noreply.github.com}}]
    label "gh/me"
  }.otherwise {
    has %W{from:notifications@github.com}
    archive
  }

  filter {
    has [{:or => %w{from:goodtime.io from:greenhouse.io}}]
    label "interviews"
  }

  # Alert Emails
  filter {
    has %W{to:alerts+aa@liftoff.io}
    label "alerts/aa"
  }.archive_unless_directed.otherwise{
    has %W{to:alerts+bidding@liftoff.io}
    label "alerts/bidding"
  }.archive_unless_directed.otherwise{
    has [{:or => %W{to:alerts+creative@liftoff.io to:alerts+labrat@liftoff.io}}]
    label "alerts/creative-tech"
  }.archive_unless_directed.otherwise{
    has [{:or => %W{to:alerts+dash@liftoff.io to:alerts+apps@liftoff.io}}]
    label "alerts/dash"
  }.archive_unless_directed.otherwise{
    has [{:or => %W{to:alerts+ml@liftoff.io to:alerts+prospector@liftoff.io}}]
    label "alerts/ml"
  }.archive_unless_directed.otherwise{
    has %W{to:alerts+datainfra@liftoff.io}
    label "alerts/data-infra"
  }.archive_unless_directed.otherwise{
    has %W{to:alerts@liftoff.io}
    label "alerts"
  }.archive_unless_directed

  filter {
    has %W{(invite.ics OR invite.vcs) has:attachment}
    label "calendar"
  }


  # A very annoying phishing email I get constantly.
  filter {
    subject "mikeq@liftoff.io has been hacked, change your password ASAP"
    delete_it
  }

  # Annoying newsletters.
  NEWSLETTERS = %W{
    hello@tune.com
    tracker-news@pivotal.io
    mail@appnexus.com
    klisacki@localytics.com
  }
  filter {
    has [NEWSLETTERS.map{ |from| "from:#{from}" }.join(" OR ")]
    label "newsletters"
    archive
  }
end

puts fs.generate
