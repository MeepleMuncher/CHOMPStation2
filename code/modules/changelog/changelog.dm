/datum/changelog
	var/static/list/changelog_items = list()

/datum/changelog/tgui_state()
	return GLOB.tgui_always_state

/datum/changelog/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "Changelog")
		ui.open()

/datum/changelog/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return
	if(action == "get_month")
		var/datum/asset/changelog_item/changelog_item = changelog_items[params["date"]]
		if (!changelog_item)
			changelog_item = new /datum/asset/changelog_item(params["date"])
			changelog_items[params["date"]] = changelog_item
		return ui.send_asset(changelog_item)

/datum/changelog/tgui_static_data()
	var/list/data = list( "dates" = list() )
	var/regex/ymlRegex = regex(@"\.yml", "g")

	for(var/archive_file in sortList(flist("html/changelogs_ch/archive/"))) // CHOMPEdit - changelog_ch
		var/archive_date = ymlRegex.Replace(archive_file, "")
		data["dates"] = list(archive_date) + data["dates"]

	return data
