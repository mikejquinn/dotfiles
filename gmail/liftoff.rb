require "rubygems"
require "gmail-britta"

EMAIL_ADDRESSES=%W{
  mike@liftoff.io
  mikeq@liftoff.io
}
GITHUB_USERNAME="mikejquinn"

INFRA_TEAM=[
  "Basil Huang",
  "Caleb Spare",
  "GaYoung Park",
  "Nicholas Feinberg",
]

DATA_PLATFORM_TEAM=[
  "Balamurugan Chandrasekaran",
  "Evan Gates",
  "Avi",
]

AA_TEAM=[
  "srikanth-hariharan-liftoff",
  "Harsha Jujjavarapu",
  "YBizzle Kim",
]

BIDDING_TEAM=[
  "Daniel MacDougall",
  "Ken Chen",
  "Kei Peralta",
  "Sam Wu",
  "devoncall",
]

PUBLISHER_TEAM=[
  "Jing Brian Zhou",
  "Dan Patz",
]

SPO_TEAM=[
  "Dhruv Ranjan",
  "Tom Skinner",
  "Jonathan Phung",
  "Kenneth Lin",
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

  [["dkulakhmetov", "daniyar"], ["alexei", "alexei"]].each do |(email, label)|
    filter {
      has %W{deliveredto:#{email}@liftoff.io -from:liftoff.io}
      label "oldemployees/#{label}"
      archive
    }
  end

  # Github Filters
  # I filter all PRs/comments from members of the DI and Bidding teams to their own
  # label. Any Github notifications that specifically target me are sent to my inbox
  # instead of being auto-archived.
  filter {
    has  %W{from:notifications@github.com}
    label "gh"
  }.archive_unless_directed
  [{names: INFRA_TEAM, label: "infra"},
   {names: DATA_PLATFORM_TEAM, label: "data-platform"},
   {names: AA_TEAM, label: "aa"},
   {names: BIDDING_TEAM, label: "bidding"},
   {names: SPO_TEAM, label: "spo"},
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
    has "from:support@lacework.com subject:Events"
    label "alerts/lacework"
    archive
  }
  filter {
    has %W{from:tickets@liftoff.io}
    label "tickets"
    archive_unless_directed
  }
  filter {
    has %W{from:device-id-list-archive@liftoff.io}
    label "alerts/device-id-list-archive"
    archive
  }
  filter {
    has %W{to:customer-success-alerts@liftoff.io}
    label "alerts/customer-success"
    archive
  }
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
    has %W{to:alerts+infra@liftoff.io}
    label "alerts/infra"
  }
  filter {
    has %W{to:alerts+dataplatform@liftoff.io}
    label "alerts/dataplatform"
  }
  filter {
    has %W{to:alerts@liftoff.io}
    label "alerts"
  }
  filter {
    has %W{to:alerts@liftoff.io -{to:me to:infra@liftoff.io to:bidding@liftoff.io to:core-eng@liftoff.io to:eng@liftoff.io}}
    label "alerts"
    archive
  }

  filter {
    has %W{(invite.ics OR invite.vcs) has:attachment}
    label "calendar"
  }
  filter {
    has %W{(invite.ics OR invite.vcs) has:attachment (subject:Declined OR subject:Accepted)}
    archive
  }

  filter {
    has %W{to:exchange@applovin.com to:support@applovin.com}
    label "exchange-partners"
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
    has %W{from:eugenisp@amazon.com subject:"CONFIDENTIAL - AWS Roadmap Items"}
    label "aws"
    archive
  }
  filter {
    has %W{to:apps@liftoff.io salesforce.com}
    label "salesforce"
    archive
  }

  filter {
    has ["Autopilot Sprint Notes",
         "Sprint Planning and Retrospective",
         "Creative production sprint planning",
         "Infra team sprint planning",
         "Core Eng Retro Notes",
         "sprint planning notes",
         "ConvX retrospective notes",
        ].map { |s| "subject:\"#{s}\"" }.join(" OR ")
    label "retrospectives"
  }

  # Annoying newsletters.
  NEWSLETTERS = %W{
    hello@tune.com
    tracker-news@pivotal.io
    mail@appnexus.com
    klisacki@localytics.com
    marketing@openx.com
  }
  filter {
    has [NEWSLETTERS.map{ |from| "from:#{from}" }.join(" OR ")]
    label "newsletters"
    archive
  }
end

puts fs.generate
