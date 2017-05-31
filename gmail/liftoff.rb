require "rubygems"
require "gmail-britta"

ENG_ALERTS=%w{beancounter grete gumshoedb haggler_global jobs karchive pinpoint scribe shadow udspatch}
DBS = %w{analytics_db orange_db cohort_db white_db blue_db}

fs = GmailBritta.filterset(:me => ["mike@liftoff.io"]) do
  filter {
    has   %w{to:notifications+deploy@liftoff.io}
    label "deploys"
    archive
  }

  # Github
  filter {
    has  %W{from:notifications@github.com}
    label "gh"
  }
  filter {
    has  %W{from:notifications@github.com Assigned to @mikejquinn}
    label "gh/assigned"
  }
  filter {
    has  %W{from:notifications@github.com @mikejquinn}
    label "gh/mentioned"
  }
  filter {
    has  %W{from:notifications@github.com "this pull request"}
    label "gh/pull-requests"
  }

  # Alerts for other teams
  filter {
    has   %W{from:alerts+shadow_apps@liftoff.io}
    label "alerts/apps/shadow"
    archive
  }
  filter {
    has   %W{from:alerts+labrat@liftoff.io}
    label "alerts/apps/labrat"
    archive
  }
  filter {
    has   %W{from:alerts+skipper@liftoff.io}
    label "alerts/apps/skipper"
    archive
  }
  filter {
    has   %W{from:alerts+jobrunner@liftoff.io}
    label "alerts/ml/prospector-job-runner"
    archive
  }
  filter {
    has   %W{from:alerts+bookie@liftoff.io}
    label "alerts/ml/bookie"
    archive
  }
  filter {
    has   %W{from:alerts+labrat@liftoff.io subject:[creative-approval-alert]}
    label "alerts/creative-approvals"
    archive
  }

  # Eng team alerts
  DBS.each do |db|
    filter {
      has   %W{from:alerts+#{db}@liftoff.io}
      label "alerts/dbs"
    }.archive_unless_directed
  end
  ENG_ALERTS.each do |app|
    filter {
      has   %W{from:alerts+#{app}@liftoff.io}
      label "alerts/#{app}"
    }.archive_unless_directed
    filter {
      has   %W{from:alerts+#{app}@liftoff.io}
      label "alerts"
    }.archive_unless_directed
  end
  filter {
    has   %W{from:alerts+user_data_store@liftoff.io}
    label "alerts/uds"
  }.archive_unless_directed
  filter {
    has   %W{from:alerts+user_data_store@liftoff.io}
    label "alerts"
  }.archive_unless_directed
  filter {
    has   %W{from:alerts+jenkins@liftoff.io to:alerts+dashgen@liftoff.io}
    label "alerts/workbench"
  }.archive_unless_directed
  filter {
    has   %W{from:alerts+jenkins@liftoff.io to:alerts+ci@liftoff.io}
    label "ci"
  }.archive_unless_directed


  # Annoying newsletters
  NEWSLETTERS = %w{hello@tune.com tracker-news@pivotal.io mail@appnexus.com klisacki@localytics.com}
  NEWSLETTERS.each do |email|
    filter {
      has %W{from:#{email}}
      label "newsletters"
      archive
    }
  end
end

puts fs.generate
