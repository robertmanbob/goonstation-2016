// Contains:
//
// - obj/item/weapon parent (now unused and commented out)
// - Esword
// - Dagger
// - Butcher's knife
// - Axe
// - Katana

////////////////////////////////////////////// Weapon parent //////////////////////////////////
/* unused now
/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
*/
/////////////////////////////////////////////// Esword /////////////////////////////////////////

/obj/item/sword
	name = "cyalume saber"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sword0"
	inhand_image_icon = 'icons/mob/inhand/hand_cswords.dmi'
	item_state = "sword0"
	var/active = 0.0
	var/bladecolor = "G"
	var/list/valid_colors = list("R","O","Y","G","C","B","P","Pi","W")
	hit_type = DAMAGE_BLUNT
	force = 1
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD | USEDELAY
	is_syndicate = 1
	mats = 18
	contraband = 5
	desc = "An illegal weapon that, when activated, uses cyalume to create an extremely dangerous saber. Can be concealed when deactivated."
	stamina_damage = 35
	stamina_cost = 30
	stamina_crit_chance = 35

	New()
		..()
		src.bladecolor = pick(valid_colors)
		if (prob(1))
			src.bladecolor = null

/obj/item/sword/attack(mob/target, mob/user)
	target.stunned += 5
	target.weakened += 5
	if(ishuman(user))
		if(active)
			var/mob/living/carbon/human/U = user
			if(U.gender == MALE) playsound(get_turf(U), pick('sound/weapons/male_cswordattack1.ogg','sound/weapons/male_cswordattack2.ogg'), 70, 0, 0, max(0.7, min(1.2, 1.0 + (30 - U.bioHolder.age)/60)))
			else playsound(get_turf(U), pick('sound/weapons/female_cswordattack1.ogg','sound/weapons/female_cswordattack2.ogg'), 70, 0, 0, max(0.7, min(1.4, 1.0 + (30 - U.bioHolder.age)/50)))
	..()

/obj/item/sword/attack_self(mob/user as mob)
	if (user.bioHolder.HasEffect("clumsy") && prob(50))
		user.visible_message("<span style=\"color:red\"><b>[user]</b> fumbles [src] and cuts \himself.</span>")
		user.TakeDamage(user.hand == 1 ? "l_arm" : "r_arm", 5, 5)
		take_bleeding_damage(user, user, 5)
	src.active = !( src.active )
	if (src.active)
		boutput(user, "<span style=\"color:blue\">The sword is now active.</span>")
		hit_type = DAMAGE_CUT
		if(ishuman(user))
			var/mob/living/carbon/human/U = user
			if(U.gender == MALE) playsound(get_turf(U),"sound/weapons/male_cswordstart.ogg", 70, 0, 0, max(0.7, min(1.2, 1.0 + (30 - U.bioHolder.age)/60)))
			else playsound(get_turf(U),"sound/weapons/female_cswordturnon.ogg" , 100, 0, 0, max(0.7, min(1.4, 1.0 + (30 - U.bioHolder.age)/50)))
		src.force = 60
		if (src.bladecolor)
			if (!(src.bladecolor in src.valid_colors))
				src.bladecolor = null
		src.icon_state = "sword1-[src.bladecolor]"
		src.item_state = "sword1-[src.bladecolor]"
		src.w_class = 4
		user.unlock_medal("The Force is strong with this one", 1)
	else
		boutput(user, "<span style=\"color:blue\">The sword can now be concealed.</span>")
		hit_type = DAMAGE_BLUNT
		if(ishuman(user))
			var/mob/living/carbon/human/U = user
			if(U.gender == MALE) playsound(get_turf(U),"sound/weapons/male_cswordturnoff.ogg", 70, 0, 0, max(0.7, min(1.2, 1.0 + (30 - U.bioHolder.age)/60)))
			else playsound(get_turf(U),"sound/weapons/female_cswordturnoff.ogg", 100, 0, 0, max(0.7, min(1.4, 1.0 + (30 - U.bioHolder.age)/50)))
		src.force = 1
		src.icon_state = "sword0"
		src.item_state = "sword0"
		src.w_class = 2
	user.update_inhands()
	src.add_fingerprint(user)
	return

/obj/item/sword/suicide(var/mob/user as mob)
	if(!active) return 0

	user.visible_message("<span style=\"color:red\"><b>[user] stabs the cyalume saber through \his chest.</b></span>")
	take_bleeding_damage(user, null, 250, DAMAGE_STAB)
	user.TakeDamage("chest", 200, 0)
	user.updatehealth()
	spawn(20)
		if (user)
			user.suiciding = 0
	return 1

/obj/item/sword/vr
	icon = 'icons/effects/VR.dmi'
	inhand_image_icon = 'icons/effects/VR_csaber_inhand.dmi'
	valid_colors = list("R","Y","G","C","B","P","W","Bl")

///////////////////////////////////////////////// Dagger /////////////////////////////////////////////////

/obj/item/dagger
	name = "sacrificial dagger"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "dagger"
	inhand_image_icon = 'icons/mob/inhand/hand_food.dmi'
	item_state = "knife"
	force = 5.0
	throwforce = 15.0
	throw_range = 5
	hit_type = DAMAGE_STAB
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD | USEDELAY
	desc = "Gets the blood to run out juuuuuust right."
	burn_type = 1
	stamina_damage = 15
	stamina_cost = 15
	stamina_crit_chance = 50

/obj/item/dagger/throw_impact(atom/A)
	if(iscarbon(A))
		if (istype(usr, /mob))
			A:lastattacker = usr
			A:lastattackertime = world.time
		A:weakened += 5
		take_bleeding_damage(A, null, 5, DAMAGE_CUT)

/obj/item/dagger/attack(target as mob, mob/user as mob)
	playsound(target, "sound/effects/bloody_stab.ogg", 60, 1)
	if(iscarbon(target))
		if(target:stat != 2)
			take_bleeding_damage(target, user, 5, DAMAGE_STAB)
	..()

/obj/item/dagger/smile
	name = "switchblade"
	force = 10.0
	throw_range = 10
	throwforce = 10.0

/obj/item/dagger/smile/attack(mob/living/target as mob, mob/user as mob)
	if(prob(10))
		var/say = pick("Why won't you smile?","Smile!","Why aren't you smiling?","Why is nobody smiling?","Smile like you mean it!","That is not a smile!","Smile, [target.name]!","I will make you smile, [target.name].","[target.name] didn't smile!")
		user.say(say)
	..()

/obj/item/dagger/syndicate
	name = "syndicate dagger"
	desc = "An ornamental dagger for syndicate higher-ups. It sounds fancy, but it's basically the munitions company equivalent of those glass cubes with the company logo frosted on."

////////////////////////////////////////// Butcher's knife /////////////////////////////////////////

/obj/item/knife_butcher //Idea stolen from the welder!
	name = "Butcher's Knife"
	desc = "A huge knife."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "knife_b"
	item_state = "knife_b"
	force = 5.0
	throwforce = 15.0
	throw_speed = 4
	throw_range = 8
	w_class = 2.0
	flags = FPRINT | TABLEPASS | NOSHIELD | USEDELAY
	var/makemeat = 1

/obj/item/knife_butcher/throw_impact(atom/A)
	if(iscarbon(A))
		if (istype(usr, /mob))
			A:lastattacker = usr
			A:lastattackertime = world.time
		A:weakened += 20
		random_brute_damage(A, 20)
		take_bleeding_damage(A, null, 10, DAMAGE_CUT)

/obj/item/knife_butcher/attack(target as mob, mob/user as mob)
	if (!istype(src,/obj/item/knife_butcher/predspear) && ishuman(target) && ishuman(user))
		if (scalpel_surgery(target,user))
			return

	playsound(target, 'sound/effects/bloody_stab.ogg', 60, 1)

	if (iscarbon(target))
		var/mob/living/carbon/C = target
		if (C.stat != 2)
			random_brute_damage(C, 20)
			take_bleeding_damage(C, user, 10, DAMAGE_STAB)
		else
			if (src.makemeat)
				logTheThing("combat", user, C, "butchers [C]'s corpse with the [src.name] at [log_loc(C)].")
				var/sourcename = C.real_name
				var/sourcejob = "Stowaway"
				if (C.mind && C.mind.assigned_role)
					sourcejob = C.mind.assigned_role
				else if (C.ghost && C.ghost.mind && C.ghost.mind.assigned_role)
					sourcejob = C.ghost.mind.assigned_role
				for (var/i=0, i<3, i++)
					var/obj/item/reagent_containers/food/snacks/ingredient/meat/humanmeat/meat = new /obj/item/reagent_containers/food/snacks/ingredient/meat/humanmeat(get_turf(C))
					meat.name = sourcename + meat.name
					meat.subjectname = sourcename
					meat.subjectjob = sourcejob
				if (C.mind)
					C.ghostize()
					qdel(C)
					return
				else
					qdel(C)
					return
	..()
	return

/obj/item/knife_butcher/suicide(var/mob/user as mob)
	user.visible_message("<span style=\"color:red\"><b>[user] slashes \his own throat with [src]!</b></span>")
	blood_slash(user, 25)
	user.TakeDamage("head", 150, 0)
	user.updatehealth()
	spawn(100)
		if (user)
			user.suiciding = 0
	return 1

/////////////////////////////////////////////////// Predator Spear ////////////////////////////////////////////

/obj/item/knife_butcher/predspear
	name = "Hunting Spear"
	desc = "A very large, sharp spear."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "predspear"
	inhand_image_icon = 'icons/mob/inhand/hand_food.dmi'
	item_state = "knife_b"
	force = 8.0
	throwforce = 35.0
	throw_speed = 6
	throw_range = 10
	makemeat = 0

/////////////////////////////////////////////////// Axe ////////////////////////////////////////////

/obj/item/axe
	name = "Axe"
	desc = "An energised battle axe."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "axe0"
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	var/active = 0.0
	hit_type = DAMAGE_CUT
	force = 40.0
	throwforce = 25.0
	throw_speed = 1
	throw_range = 5
	w_class = 3.0
	contraband = 80
	flags = FPRINT | CONDUCT | NOSHIELD | TABLEPASS | USEDELAY
	stamina_damage = 50
	stamina_cost = 45
	stamina_crit_chance = 5

/obj/item/axe/attack(target as mob, mob/user as mob)
	..()

/obj/item/axe/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		boutput(user, "<span style=\"color:blue\">The axe is now energised.</span>")
		src.hit_type = DAMAGE_BURN
		src.force = 150
		src.icon_state = "axe1"
		src.w_class = 5
	else
		boutput(user, "<span style=\"color:blue\">The axe can now be concealed.</span>")
		src.hit_type = DAMAGE_CUT
		src.force = 40
		src.icon_state = "axe0"
		src.w_class = 5
	src.add_fingerprint(user)
	user.update_inhands()
	return

/obj/item/axe/suicide(var/mob/user as mob)
	user.visible_message("<span style=\"color:red\"><b>[user] slashes \his own throat with [src]!</b></span>")
	blood_slash(user, 25)
	user.TakeDamage("head", 150, 0)
	user.updatehealth()
	spawn(100)
		if (user)
			user.suiciding = 0
	return 1

/obj/item/axe/vr
	icon = 'icons/effects/VR.dmi'


/////////////////////////////////////////////////// Katana ////////////////////////////////////////////
//PS the description can be shortened if you find it annoying and you are a jerk.

//You probably want to spawn the sheath in instead of this.
/obj/item/katana
	name = "katana"
	desc = "That's it. I'm sick of all this 'Masterwork Cyalume Saber' bullshit that's going on in the SS13 system right now. Katanas deserve much better than that. Much, much better than that. I should know what I'm talking about. I myself commissioned a genuine katana in Space Japan for 2,400,000 Nuyen (that's about 20,000 credits) and have been practicing with it for almost 2 years now. I can even cut slabs of solid mauxite with my katana. Space Japanese smiths spend light-years working on a single katana and fold it up to a million times to produce the finest blades known to space mankind. Katanas are thrice as sharp as Syndicate sabers and thrice as hard for that matter too. Anything a c-saber can cut through, a katana can cut through better. I'm pretty sure a katana could easily bisect a drunk captain wearing full captain's armor with a simple tap. Ever wonder why the Syndicate never bothered conquering Space Japan? That's right, they were too scared to fight the disciplined Space Samurai and their space katanas of destruction. Even in World War 72, Nanotrasen soldiers targeted the men with the katanas first because their killing power was feared and respected."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "katana"
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	hit_type = DAMAGE_CUT
	flags = FPRINT | TABLEPASS | NOSHIELD | USEDELAY
	force = 15 //Was at 5, but that felt far too weak. C-swords are at 60 in comparison. 15 is still quite a bit of damage, but just not insta-crit levels.
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	is_syndicate = 1
	contraband = 5 //Fun fact: sheathing your katana makes you 100% less likely to be tazed by beepsky, probably
	w_class = 4
	hitsound = 'sound/effects/bloody_stab.ogg'

/obj/item/katana/attack(mob/living/carbon/human/target as mob, mob/user as mob)
	if(target == user) //Can't cut off your own limbs, dumbo
		return ..()
	var/zoney = user.zone_sel.selecting
	var/mob/living/carbon/human/H = target
	switch(zoney)
		if("head")
			if(!target.limbs.r_arm && !target.limbs.l_arm && !target.limbs.l_leg && !target.limbs.r_leg) //Does the target not have all of their limbs?
				target.organHolder.drop_organ("head") //sever_limb doesn't apply to heads :(
			return ..()
		if("chest")
			return ..()
		if("r_arm")
			H.sever_limb(zoney)
			return ..()
		if("l_arm")
			H.sever_limb(zoney)
			return ..()
		if("r_leg")
			H.sever_limb(zoney)
			return ..()
		if("l_leg")
			H.sever_limb(zoney)
			return ..()
	..()

/obj/item/katana/suicide(var/mob/user as mob)
	user.visible_message("<span style=\"color:red\"><b>[user] thrusts [src] through their stomach!</b></span>")
	var/say = pick("Kono shi wa watashinokazoku ni meiyo o ataeru","Haji no mae no shi", "Watashi wa kyo nagura reta.", "Teki ga katta", "Shinjiketo ga modotte kuru")
	user.say(say)
	blood_slash(user, 25)
	user.TakeDamage("chest", 150, 0)
	user.updatehealth()
	spawn(100)
		if (user)
			user.suiciding = 0
	return 1

//There's probably a better way to do this, but i'm a bad coder. Yell at me at the forums if you have a better idea. - Robert/robertmanbob
/obj/item/sheath
	name = "sheath"
	desc = "It can clean a bloodied katana, and also allows for easier storage of a katana"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "sheathed"
	inhand_image_icon = 'icons/mob/inhand/hand_weapons.dmi'
	item_state = "sheathedhand"
	var/katana = 1
	hit_type = DAMAGE_BLUNT
	force = 1
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 3
	flags = FPRINT | TABLEPASS | NOSHIELD | USEDELAY | ONBELT
	is_syndicate = 1

	New()
		..()
		var/obj/item/sheath/P = new/obj/item/katana
		P.set_loc(src)

	attack_hand(mob/living/carbon/human/user as mob)
		if(user.r_hand == src || user.l_hand == src || user.belt == src)
			if(src.katana == 1) //Checks if a katana is SUPPOSED to be in the sheath
				var/obj/item/sheath/P = locate(/obj/item/katana) in src //Removes said katana from sheath
				P.clean_forensic()
				boutput(user, "You draw [P] from [src].")
				icon_state = "sheath"
				item_state = "sheathhand"
				user.put_in_hand_or_drop(P)
				katana = 0 //Katana shouldn't still be sheath
				user.update_clothing()
			else if(user.r_hand == src || user.l_hand == src) //Trying to take out a katana that doesn't exist?
				boutput(user, "<span style=\"color:red\">There is no katana sheathed</span>")
				return ..() //Swaps hands as normal after informing the player of katana deficiency.
			else
				return ..()//Katana doesn't exist, and takes the sheath off your belt.

		else
			return ..()

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/katana) && src.katana == 0)
			icon_state = "sheathed"
			item_state = "sheathedhand"
			user.u_equip(W)
			W.set_loc(src)
			user.update_clothing()
			katana = 1 //WOW, katana SHOULD be in the sheath now.
			boutput(user, "<span style=\"color:blue\">You sheathe [W] in [src].</span>")
		else ..()
