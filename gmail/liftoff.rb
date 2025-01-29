require "rubygems"
require "gmail-britta"

EMAIL_ADDRESSES=%W{
  mike@liftoff.io
  mikeq@liftoff.io
}
GITHUB_USERNAME="mikejquinn"

INFRA_TEAM=[
  "Basil Huang",
  "GaYoung Park",
  "Nicholas Feinberg",
  "Stefan Toubia",
  "Andy Sponring",
]

TS_TEAM=[
  "Frank Fishburn",
  "Aibek Yessenalian",
  "Caleb Spare",
  "Daniel MacDougall",
]

BIDDING_TEAM=[
  "Kei Peralta",
  "Sam Wu",
  "Patrick Phang",
]

EXP_PLATFORM_TEAM=[
  "Patrick Waters",
  "James Dang",
]

LANG_TOOL_TEAM=[
  "Kevin Le",
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

  [["dkulakhmetov", "daniyar"],
   ["alexei", "alexei"],
   ["ben", "ben"],
   ["ken.chen", "ken"],
   ["jfan", "johnny"],
   ["wgoi", "wesley"],
   ["dcall", "devon"]].each do |(email, label)|
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
   {names: TS_TEAM, label: "trainingserving"},
   {names: BIDDING_TEAM, label: "bidding"},
   {names: EXP_PLATFORM_TEAM, label: "exp-platform"},
   {names: LANG_TOOL_TEAM, label: "language-tools"},
  ].each do |m|
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

  filter {
    has %W{from:support@lacework.net subject:"Events Summary"}
    label "alerts/lacework"
    archive
  }

  # Alert Emails
  ["aa",
   "bidding",
   {"creative" => "creative-tech"},
   "dash",
   "ml",
   "infra",
   "dataplatform",
   "trainingserving",
   "convx",
  ].each do |m|
    unless m.is_a?(Hash)
      m = {m => m}
    end
    m.each do |a, label|
      filter {
        has %W{to:alerts+#{a}@liftoff.io}
        label "alerts/#{label}"
      }
    end
  end

  filter {
    has %W{to:customer-success-alerts@liftoff.io}
    label "alerts/customer-success"
    archive
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
    has %W{from:docs.google.com}
    label "google-docs"
  }

  filter {
    has %W{from:(eugenisp@amazon.com OR didow@amazon.com) subject:"CONFIDENTIAL - AWS Roadmap Items"}
    label "aws"
    archive
  }
  filter {
    has %W{from:freetier@costalerts.amazonaws.com}
    label "aws"
    archive
  }

  # filter {
  #   has %W{from:kanako.abe@supership.jp j


  filter {
    has ["Autopilot Sprint Notes",
         "Sprint Planning and Retrospective",
         "Creative platform sprint planning",
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
