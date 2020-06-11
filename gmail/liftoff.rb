require "rubygems"
require "gmail-britta"

EMAIL_ADDRESSES=%W{
  mike@liftoff.io
  mikeq@liftoff.io
}
GITHUB_USERNAME="mikejquinn"

DI_TEAM=[
  "Andrey Klochkov",
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
  # I filter all PRs/comments from members of the DI and Bidding teams to their own
  # label. Any Github notifications that specifically target me are sent to my inbox
  # instead of being auto-archived.
  filter {
    has  %W{from:notifications@github.com}
    label "gh"
  }.archive_unless_directed
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
    has [{:or => %w{from:goodtime.io from:greenhouse.io}}]
    label "interviews"
  }

  # Alert Emails
  filter {
    has %W{to:alerts+aa@liftoff.io}
    label "alerts/aa"
  }
  filter {
    has %W{to:alerts+bidding@liftoff.io}
    label "alerts/bidding"
  }
  filter {
    has %W{to:alerts+creative@liftoff.io}
    label "alerts/creative-tech"
  }
  filter {
    has %W{to:alerts+dash@liftoff.io}
    label "alerts/dash"
  }
  filter {
    has %W{to:alerts+ml@liftoff.io}
    label "alerts/ml"
  }
  filter {
    has %W{to:alerts+datainfra@liftoff.io}
    label "alerts/data-infra"
  }
  filter {
    has %W{to:alerts@liftoff.io}
    label "alerts"
  }
  filter {
    has %W{to:alerts@liftoff.io -{to:me to:data-infra@liftoff.io to:bidding@liftoff.io to:core-eng@liftoff.io to:eng@liftoff.io}}
    label "alerts"
    archive
  }

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
