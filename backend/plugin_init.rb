MarcXMLAuthAgentBaseMap.module_eval do

    def BASE_RECORD_MAP(opts = {:import_events => false, :import_subjects => false})
    import_events   = opts[:import_events]
    import_subjects = false # SI override. Never import subjects.

    {
      # AGENT PERSON
      "//datafield[@tag='100' and (@ind1='1' or @ind1='0')]" => {
        :obj => :agent_person,
        :map => agent_person_base(import_events, import_subjects)
      },
      # AGENT CORPORATE ENTITY
      "//datafield[@tag='110' or @tag='111']" => {
        :obj => :agent_corporate_entity,
        :map => agent_corporate_entity_base(import_events, import_subjects)
      },
      # AGENT FAMILY
      "//datafield[@tag='100' and @ind1='3']" => {
        :obj => :agent_family,
        :map => agent_family_base(import_events, import_subjects)
      }
    }
  end

  def agent_person_base(import_events, import_subjects)
    p = {
      'self::datafield' => agent_person_name_map(:name_person, :names),
      "parent::record/datafield[@tag='400' and (@ind1='1' or @ind1='0')]" => agent_person_name_map(:name_person, :names),
      # SI override. Don't import gender.
      # "parent::record/datafield[@tag='375']/subfield[@code='a']" => agent_gender_map
    }.merge(shared_subrecord_map(import_events, import_subjects))

    if import_subjects
      p.merge!({
        "parent::record/datafield[@tag='372']/subfield[@code='a']" => agent_topic_map
      })
    end

    p
  end

  def shared_subrecord_map(import_events, import_subjects)
    h = {
      'parent::record/leader' => agent_record_control_map,
      "parent::record/controlfield[@tag='001'][not(following-sibling::controlfield[@tag='003']/text()='DLC' and following-sibling::datafield[@tag='010'])]" => agent_record_identifiers_base_map("//record/controlfield[@tag='001']"),
      "parent::record/datafield[@tag='010']" => agent_record_identifiers_base_map("descendant::subfield[@code='a']"),
      "parent::record/datafield[@tag='016']" => agent_record_identifiers_base_map("descendant::subfield[@code='a']"),
      "parent::record/datafield[@tag='024']" => agent_record_identifiers_base_map("descendant::subfield[@code='a' or @code='0' or @code='1'][1]"),
      "parent::record/datafield[@tag='035']" => agent_record_identifiers_base_map("descendant::subfield[@code='a']"),
      "parent::record/datafield[@tag='040']/subfield[@code='e']" => convention_declaration_map,
      "parent::record/datafield[@tag='046']" => dates_map,

      "parent::record/datafield[@tag='377']" => used_language_map,

      # SI override. Lots of stuff removed here, until we can figure out how to handle IDs, etc. (also, once we have these IDs, can't we just merge this extra subject data at the time of export / display?)
      "parent::record/datafield[@tag='670']" => agent_sources_map,
      "parent::record/datafield[@tag='678']" => bioghist_note_map,
      "parent::record/datafield[@tag='040']/subfield[@code='d']" => {
        :obj => :agent_other_agency_codes,
        :rel => :agent_other_agency_codes,
        :map => {
          "self::subfield" => proc { |aoac, node|
            aoac['maintenance_agency'] = node.inner_text
          }
        }
      },
      "parent::record" => proc { |record, node|
        # apply the more complicated inter-leaf logic
        record['agent_other_agency_codes'].reject! { |subrecord|
          subrecord['maintenance_agency'] == record['agent_record_controls'][0]['maintenance_agency']
        }
      }
    }

    if import_events
      h.merge!({
        "parent::record/controlfield[@tag='005']" => maintenance_history_map
      })
    end
    h
  end

end
