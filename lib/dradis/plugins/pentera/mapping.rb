module Dradis::Plugins::Pentera
  module Mapping
    DEFAULT_MAPPING = {
    evidence: {
      'Port' => '{{ pentera[evidence.port] }}',
      'Protocol' => '{{ pentera[evidence.protocol] }}'
    },
    issue: {
      'Title' => '{{ pentera[issue.name] }}',
      'Summary' => '{{ pentera[issue.summary] }}',
      'Severity' => '{{ pentera[issue.severity] }}',
      'Priority' => '{{ pentera[issue.priority] }}',
      'Insight' => '{{ pentera[issue.insight] }}',
      'Remediation' => '{{ pentera[issue.remediation] }}'
    }
  }.freeze

  SOURCE_FIELDS = {
    evidence: [
      'evidence.found_on',
      'evidence.port',
      'evidence.protocol',
      'evidence.target',
      'evidence.target_id'
    ],
    issue: [
      'issue.insight',
      'issue.name',
      'issue.priority',
      'issue.remediation',
      'issue.summary',
      'issue.severity'
    ]
  }.freeze
  end
end
