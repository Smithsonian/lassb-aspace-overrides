require 'spec_helper'
require 'converter_spec_helper'

require "#{ASUtils.find_base_directory}/backend/app/converters/marcxml_auth_agent_converter"

describe 'MARCXML Auth Agent converter' do
  def my_converter
    MarcXMLAuthAgentConverter
  end

  let(:person_agent_1) do
    File.expand_path('../../../../backend/spec/examples/marc/authority_john_davis.xml',
                     File.dirname(__FILE__))
  end

  let(:corporate_agent_1) do
    File.expand_path('../../../../backend/spec/examples/marc/IAS.xml',
                     File.dirname(__FILE__))
  end

  let(:family_agent_1) do
    File.expand_path('../../../../backend/spec/examples/marc/Wood.xml',
                     File.dirname(__FILE__))
  end

  describe 'agent person' do
    it 'does not import agent gender' do
      record = convert(person_agent_1).select { |r| r['jsonmodel_type'] == 'agent_person' }.first

      expect(record['agent_genders']).to match_array([])
    end

    it 'does not imports topics' do
      record = convert(person_agent_1).select { |r| r['jsonmodel_type'] == 'agent_person' }.first

      expect(record['agent_topics'].length).to eq(0)
    end
  end

  describe 'agent family' do
    it 'does not import functions' do
      record = convert(family_agent_1).select { |r| r['jsonmodel_type'] == 'agent_family' }.first

      expect(record['agent_functions'].length).to eq(0)
    end
  end

  describe 'agent_corporate_entity' do
    it 'does not import functions' do
      record = convert(corporate_agent_1).select { |r| r['jsonmodel_type'] == 'agent_corporate_entity' }.first

      expect(record['agent_functions'].length).to eq(0)
    end
  end

  describe 'common subrecords' do
    it 'does not import related agents' do
      raw = convert(corporate_agent_1)
      agent_corp_records = raw.select { |r| r['jsonmodel_type'] == 'agent_corporate_entity' }
      agent_person_records = raw.select { |r| r['jsonmodel_type'] == 'agent_person' }

      expect(agent_corp_records.length).to eq(1)
      expect(agent_person_records.length).to eq(0)
    end
  end
end
