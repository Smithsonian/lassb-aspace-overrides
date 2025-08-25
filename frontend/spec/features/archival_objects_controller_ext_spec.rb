# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe ArchivalObjectsController, type: :controller do
  render_views

  before(:each) do
    set_repo($repo)
    session = User.login('admin', 'admin')
    User.establish_session(controller, session, 'admin')
    controller.session[:repo_id] = JSONModel.repository
  end

  describe "New Archival Object" do
    let (:resource) { create(:json_resource) }
    let (:archival_object_with_note) { create(:json_archival_object,
                                               :notes => [ build(:json_note_singlepart) ],
                                               :resource => {'ref' => resource.uri}) }

    it "does not duplicate persistent id when duplicating an archival object note" do
      get :new, params: { resource_id: resource.id,
                          duplicate_from_archival_object: { uri: archival_object_with_note.uri } }

      expect(response.status).to eq 200
      result = Capybara.string(response.body)

      result.find(:css, "#archival_object_notes__0__persistent_id_") do |new_persistent_id|
        expect(new_persistent_id.value).to eq("")
      end
    end
  end
end
