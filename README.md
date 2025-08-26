# lassb-aspace-overrides

This plugin implements the following overrides:

* Redirects the Bulk Import Templates link to SI's ArchivesSpace manual (see `frontend/views/shared/_header_repository.html.erb`)
* Removes the link for non-admin users to update their own user accounts (see `frontend/views/shared/_header_user.html.erb`)
* Remove the "Duplicate Resource" button from the resource toolbar (see `frontend/views/shared/_resource_toolbar.html.erb`)
* Overrides the MarcXMLAuthAgentBaseMap module to ensure that related agents and subjects are NOT imported via the LCNAF plugin (and other MARC agent imports), since those additional headings resulted in duplicates that lacked authority identifiers (see `backend/plugin_init.rb`)

## Using alongside other toolbar plugins (ex: SOVA button, SNAC plugin)

Since this plugin overrides a shared toolbar partial - `shared/_resource_toolbar.html.erb` - it will conflict with plugins that also modify this view.  For the Smithsonian, this currently includes the [SOVA button plugin](https://github.com/Smithsonian/caas_aspace_sova_button).  To address this, this plugin conditionally inserts the SOVA button resource toolbar override if `caas_aspace_sova_button` is present in `AppConfig`.  ASpace maintainers should be aware of this when upgrading ArchivesSpace and/or the SOVA plugin.
