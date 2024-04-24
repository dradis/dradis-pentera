module Dradis::Plugins::Pentera
  class Importer < Dradis::Plugins::Upload::Importer
    def self.templates
      { evidence: 'evidence', issue: 'issue' }
    end

    # The framework will call this function if the user selects this plugin from
    # the dropdown list and uploads a file.
    # @returns true if the operation was successful, false otherwise
    def import(params = {})
      file_content = File.read(params[:file])

      # Parse the uploaded file into a Ruby Hash
      logger.info { "Parsing Pentera output from #{ params[:file] }..." }
      @data = MultiJson.decode(file_content)
      logger.info { 'Done.' }

      @node_cache = {}
      parse_hosts
      parse_vulnerabilities

      true
    rescue MultiJson::ParseError
      logger.error 'ERROR: invalid JSON file uploaded. '\
        'Are you sure you uploaded a Pentera file?'

      false
    end

    private

    def parse_hosts
      @data['hosts'].each do |host|
        host_label = host['hostname'] || host['ip']
        logger.info { "\tHost: #{host_label}" }

        node = content_service.create_node(label: host_label)

        node.set_property(:ip, host['ip']) if host['ip']
        node.set_property(:hostname, host['hostname']) if host['hostname']
        node.set_property(:os, host['os_name']) if host['os_name']
        node.set_property(:identifier, host['id']) if host['id']

        if host['domain']
          node.set_property(:domain_name, host['domain']['name'])
          node.set_property(:fqdn, host['domain']['FQDN'])
          node.set_property(:netbios, host['domain']['netBIOS'])
        end

        parse_services(node, host['services'])

        node.save
        @node_cache[host['id']] = node
      end
    end

    def parse_services(node, services)
      services.each do |service|
        node.set_service({
          name: service['name'],
          port: service['port'],
          protocol: service['transport'],
          state: service['state'],
          source: :pentera
        })
      end
    end

    def parse_vulnerabilities
      @data['vulnerabilities'].each do |vulnerability|
        issue_text = mapping_service.apply_mapping(source: 'issue', data: vulnerability)
        issue = content_service.create_issue(text: issue_text, id: vulnerability['id'])

        node = @node_cache[vulnerability['target_id']]
        if node
          evidence_text = mapping_service.apply_mapping(source: 'evidence', data: vulnerability)
          content_service.create_evidence(content: evidence_text, issue: issue, node: node)
        end
      end
    end
  end
end
