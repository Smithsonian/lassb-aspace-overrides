# lassb-aspace-overrides

This plugin implements the following overrides:

* Redirects the Bulk Import Templates link to SI's ArchivesSpace manual (see `frontend/views/shared/_header_repository.html.erb`)
* Removes the link for non-admin users to update their own user accounts (see `frontend/views/shared/_header_user.html.erb`)
* Overrides the MarcXMLAuthAgentBaseMap module to ensure that related agents and subjects are NOT imported via the LCNAF plugin (and other MARC agent imports), since those additional headings resulted in duplicates that lacked authority identifiers (see `backend/plugin_init.rb`)
