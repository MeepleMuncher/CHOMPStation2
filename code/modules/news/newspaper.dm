//########################################################################################################################
//###################################### NEWSPAPER! ######################################################################
//########################################################################################################################

/obj/item/newspaper
	name = "newspaper"
	desc = "An issue of The Griffon, the newspaper circulating aboard most stations."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "newspaper"
	w_class = ITEMSIZE_SMALL	//Let's make it fit in trashbags!
	attack_verb = list("bapped")
	var/screen = 0
	var/pages = 0
	var/curr_page = 0
	var/list/datum/feed_channel/news_content = list()
	var/datum/feed_message/important_message = null
	var/scribble=""
	var/scribble_page = null
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

/obj/item/newspaper/attack_self(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		var/dat
		pages = 0
		switch(screen)
			if(0) //Cover
				dat+="<DIV ALIGN='center'>" + span_bold(span_giganteus("The Griffon")) + "</div>"
				dat+="<DIV ALIGN='center'>" + span_normal("[using_map.company_name]-standard newspaper, for use on [using_map.company_name] Space Facilities") + "</div><HR>"
				if(isemptylist(news_content))
					if(important_message)
						dat+="Contents:<BR><ul>" + span_bold(span_red("**") + "Important Security Announcement" + span_red("**")) + " " + span_normal("\[page [pages+2]\]") + "<BR></ul>"
					else
						dat+=span_italics("Other than the title, the rest of the newspaper is unprinted...")
				else
					dat+="Contents:<BR><ul>"
					for(var/datum/feed_channel/NP in news_content)
						pages++
					if(important_message)
						dat+=span_bold(span_red("**") + "Important Security Announcement" + span_red("**")) + " " + span_normal("\[page [pages+2]\]") + "<BR>"
					var/temp_page=0
					for(var/datum/feed_channel/NP in news_content)
						temp_page++
						dat+=span_bold("[NP.channel_name]") + " " + span_normal("\[page [temp_page+1]\]") + "<BR>"
					dat+="</ul>"
				if(scribble_page==curr_page)
					dat+="<BR>" + span_italics("There is a small scribble near the end of this page... It reads: \"[scribble]\"")
				dat+= "<HR><DIV STYLE='float:right;'><A href='byond://?src=\ref[src];next_page=1'>Next Page</A></DIV> <div style='float:left;'><A href='byond://?src=\ref[human_user];mach_close=newspaper_main'>Done reading</A></DIV>"
			if(1) // X channel pages inbetween.
				for(var/datum/feed_channel/NP in news_content)
					pages++ //Let's get it right again.
				var/datum/feed_channel/C = news_content[curr_page]
				dat+=span_huge(span_bold("[C.channel_name]")) + span_small(" \[created by: " + span_maroon("[C.author]") + "\]") + "<BR><BR>"
				if(C.censored)
					dat+="This channel was deemed dangerous to the general welfare of the station and therefore marked with a " + span_bold(span_red("D-Notice")) + ". Its contents were not transferred to the newspaper at the time of printing."
				else
					if(isemptylist(C.messages))
						dat+="No Feed stories stem from this channel..."
					else
						dat+="<ul>"
						var/i = 0
						for(var/datum/feed_message/MESSAGE in C.messages)
							i++
							dat+="[MESSAGE.title] <BR>"
							dat+="-[MESSAGE.body] <BR>"
							if(MESSAGE.img)
								user << browse_rsc(MESSAGE.img, "tmp_photo[i].png")
								dat+="<img src='tmp_photo[i].png' width = '180'><BR>"
							dat+=span_small("\[[MESSAGE.message_type] by " + span_maroon("[MESSAGE.author]") + "\]") + "<BR><BR>"
						dat+="</ul>"
				if(scribble_page==curr_page)
					dat+="<BR>" + span_italics("There is a small scribble near the end of this page... It reads: \"[scribble]\"")
				dat+= "<BR><HR><DIV STYLE='float:left;'><A href='byond://?src=\ref[src];prev_page=1'>Previous Page</A></DIV> <DIV STYLE='float:right;'><A href='byond://?src=\ref[src];next_page=1'>Next Page</A></DIV>"
			if(2) //Last page
				for(var/datum/feed_channel/NP in news_content)
					pages++
				if(important_message!=null)
					dat+="<DIV STYLE='float:center;'>" + span_huge(span_bold("Wanted Issue:")) + "</DIV><BR><BR>"
					dat+=span_bold("Criminal name") + ": " + span_maroon("[important_message.author]") + "<BR>"
					dat+=span_bold("Description") + ": [important_message.body]<BR>"
					dat+=span_bold("Photo:") + ": "
					if(important_message.img)
						user << browse_rsc(important_message.img, "tmp_photow.png")
						dat+="<BR><img src='tmp_photow.png' width = '180'>"
					else
						dat+="None"
				else
					dat+=span_italics("Apart from some uninteresting Classified ads, there's nothing on this page...")
				if(scribble_page==curr_page)
					dat+="<BR>" + span_italics("There is a small scribble near the end of this page... It reads: \"[scribble]\"")
				dat+= "<HR><DIV STYLE='float:left;'><A href='byond://?src=\ref[src];prev_page=1'>Previous Page</A></DIV>"
			else
				dat+="I'm sorry to break your immersion. This shit's bugged. Report this bug to Agouri, polyxenitopalidou@gmail.com"

		dat+="<BR><HR><div align='center'>[curr_page+1]</div>"
		human_user << browse("<html>[dat]</html>", "window=newspaper_main;size=300x400")
		onclose(human_user, "newspaper_main")
	else
		to_chat(user, span_infoplain("The paper is full of intelligible symbols!"))

/obj/item/newspaper/Topic(href, href_list)
	var/mob/living/U = usr
	..()
	if((src in U.contents) || (istype(loc, /turf) && in_range(src, U)))
		U.set_machine(src)
		if(href_list["next_page"])
			if(curr_page == pages+1)
				return //Don't need that at all, but anyway.
			if(curr_page == pages) //We're at the middle, get to the end
				screen = 2
			else
				if(curr_page == 0) //We're at the start, get to the middle
					screen = 1
			curr_page++
			playsound(src, "pageturn", 50, 1)

		else if(href_list["prev_page"])
			if(curr_page == 0)
				return
			if(curr_page == 1)
				screen = 0

			else
				if(curr_page == pages+1) //we're at the end, let's go back to the middle.
					screen = 1
			curr_page--
			playsound(src, "pageturn", 50, 1)

		if(istype(src.loc, /mob))
			attack_self(src.loc)

/obj/item/newspaper/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/pen))
		if(scribble_page == curr_page)
			to_chat(user, span_blue("There's already a scribble in this page... You wouldn't want to make things too cluttered, would you?"))
		else
			var/s = sanitize(tgui_input_text(user, "Write something", "Newspaper", ""))
			s = sanitize(s)
			if(!s)
				return
			if(!in_range(src, user) && src.loc != user)
				return
			scribble_page = curr_page
			scribble = s
			attack_self(user)
		return
