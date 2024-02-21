require 'spec_helper'

describe Dradis::Plugins::Pentera::Importer do
  before(:each) do
    # Stub template service
    templates_dir = File.expand_path('../../../../../templates', __FILE__)
    expect_any_instance_of(Dradis::Plugins::TemplateService)
    .to receive(:default_templates_dir).and_return(templates_dir)

    # Init services
    plugin = Dradis::Plugins::Pentera

    @content_service = Dradis::Plugins::ContentService::Base.new(
      logger: Logger.new(STDOUT),
      plugin: plugin
    )

    @importer = plugin::Importer.new(
      content_service: @content_service
    )

    # Stub dradis-plugins methods
    #
    # They return their argument hashes as objects mimicking
    # Nodes, Issues, etc
    allow(@content_service).to receive(:create_node) do |args|
      obj = OpenStruct.new(args)
      obj.define_singleton_method(:set_property) { |*| }
      obj.define_singleton_method(:set_service) { |*| }
      obj
    end
  end

  it 'does not import invalid json' do
    expect(@importer).to_not receive(:parse_hosts)
    expect(@importer).to_not receive(:parse_vulnerabilities)

    expect(
      @importer.import(file: 'spec/fixtures/files/pentera_invalid.json')
    ).to eq false
  end

  it 'creates nodes, issues, and evidence' do
    expect(@content_service).to receive(:create_node).with(hash_including label: 'hostname').once

    issue_text =
      "#[Title]#\nSample Vulnerability\n\n#[Summary]#\nSample Description\n\n"\
      "#[Severity]#\n9.3\n\n#[Priority]#\n1\n\n#[Insight]#\nSample Insight\n\n"\
      "#[Remediation]#\nSample Remediation\n"
    expect(@content_service).to receive(:create_issue).with(id: 'test_id', text: issue_text).once

    evidence_text = "#[Port]#\n80\n\n#[Protocol]#\nhttp\n"
    expect(@content_service).to receive(:create_evidence).with(hash_including(content: evidence_text)).once

    # Run the import
    @importer.import(file: 'spec/fixtures/files/pentera.json')
  end
end
