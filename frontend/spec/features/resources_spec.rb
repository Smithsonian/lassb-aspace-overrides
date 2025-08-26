# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

describe 'Resources', js: true do
  before(:all) do
    @repository = create(:repo, repo_code: "resources_test_#{Time.now.to_i}")
    set_repo @repository
    @user = create_user(@repository => ['repository-managers'])
  end

  before(:each) do
    login_user(@user)
    ensure_repository_access
    select_repository(@repository)
  end

  it 'hides the duplicate resource button' do
    login_admin
    select_repository(@repository)

    now = Time.now.to_i
    resource = create(:resource, title: "Resource Title #{now}")

    visit "resources/#{resource.id}/edit"

    expect(page).to have_selector('h2', visible: true, text: "#{resource.title} Resource")
    expect(page).not_to have_content('Duplicate Resource')
  end
end
