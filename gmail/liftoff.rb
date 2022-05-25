require "rubygems"
require "gmail-britta"

EMAIL_ADDRESSES=%W{
  mike@liftoff.io
  mikeq@liftoff.io
}
GITHUB_USERNAME="mikejquinn"

DI_TEAM=[
  "Alexei Pesic",
  "bhuang-liftoff",
  "Caleb Spare",
  "Evan Gates",
  "GaYoung Park",
  "Nicholas Feinberg"
]

BIDDING_TEAM=[
  "Daniel MacDougall",
  "Ken Chen",
  "Kei Peralta"
]

PUBLISHER_TEAM=[
  "Andy Sponring",
  "Anton Kapralov",
  "Jing Brian Zhou",
  "Tao Liu",
  "Dan Patz"
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
  [{names: DI_TEAM, label: "data-infra"},
   {names: BIDDING_TEAM, label: "bidding"},
   {names: PUBLISHER_TEAM, label: "publisher"}].each do |m|
    filter {
      names = m[:names].map { |n| "from:\"#{n}\"" }.join(' ')
      has "{#{names}} from:notifications@github.com"
      label "gh/#{m[:label]}"
    }
  end

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

  filter {
    has %W{from:pivotaltracker.com}
    label "pivotal"
  }
  filter {
    has %W{from:from:docs.google.com}
    label "google-docs"
  }

  filter {
    has %W{from:dsp.reports@fyber.com}
    label "reports"
    archive_unless_directed
  }

  filter {
    has ["Autopilot Sprint Notes",
         "Creative production sprint planning",
         "Core Eng Retro Notes",
         "ConvX US Sprint notes",
         "ConvX retrospective notes",
         "Publisher team sprint"
        ].map { |s| "subject:\"#{s}\"" }.join(" OR ")
    label "retrospectives"
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
