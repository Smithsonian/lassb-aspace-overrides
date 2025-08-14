ArchivalObjectsController.class_eval do

  def new
    if params[:duplicate_from_archival_object]
      new_find_opts = find_opts
      new_find_opts["resolve[]"].push("top_container::container_locations")

      archival_object_id = params[:duplicate_from_archival_object][:uri].split('/').pop

      @archival_object = JSONModel(:archival_object).find(archival_object_id, new_find_opts)
      @archival_object.ref_id = nil
      @archival_object.instances = []
      @archival_object.position = params[:position]
      @archival_object.notes.each do |note|
        if note.is_a?(Hash)
          note.delete('persistent_id')
        end
      end

      flash[:success] = t("archival_object._frontend.messages.duplicated", archival_object_display_string: clean_mixed_content(@archival_object.display_string))
    else
      @archival_object = ArchivalObject.new._always_valid!
      @archival_object.parent = {'ref' => ArchivalObject.uri_for(params[:archival_object_id])} if params.has_key?(:archival_object_id)
      @archival_object.resource = {'ref' => Resource.uri_for(params[:resource_id])} if params.has_key?(:resource_id)
      @archival_object.position = params[:position]
      if defaults = user_defaults('archival_object')
        @archival_object.update(defaults.values)
      end

      if params[:accession_id]
        acc = Accession.find(params[:accession_id], find_opts)
        @archival_object.populate_from_accession(acc)

        flash.now[:info] = t("archival_object._frontend.messages.spawned", accession_display_string: clean_mixed_content(acc.title))
        flash[:spawned_from_accession] = acc.id
      end
    end

    return render_aspace_partial :partial => "archival_objects/new_inline" if inline?
  end
end
