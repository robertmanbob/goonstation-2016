//Shamelessly stolen from machoman code.

/mob/living/carbon/human/shinobi
	New()
		..()
		spawn(0)
			if(src.bioHolder && src.bioHolder.mobAppearance)
				src.bioHolder.mobAppearance.customization_first = "Ponytail"

				spawn(10)
					src.bioHolder.mobAppearance.UpdateMob()

			//src.mind = new
			src.gender = "male"
			src.real_name = "Wolf"

			if (!src.reagents)
				var/datum/reagents/R = new/datum/reagents(1000)
				src.reagents = R
				R.my_atom = src

			//src.equip_if_possible(new /obj/item/sheath, slot_r_store) uncomment this if in actual code with the katana implemented.

	Life(datum/controller/process/mobs/parent)
		if (..(parent))
			return 1

	show_inv(mob/user)
		if (src.stance == "defensive")
			shinobi_parry(user)
			return
		..()
		return

	attack_hand(mob/user)
		if (src.stance == "defensive" && prob(70))
			src.visible_message("<span style=\"color:red\"><B>[user] attempts to attack [src]!</B></span>")
			playsound(src.loc, "sound/weapons/punchmiss.ogg", 50, 1)
			sleep(2)
			shinobi_parry(user)
			return
		..()
		return

	attackby(obj/item/W, mob/user)
		if (src.stance == "defensive" && prob(90))
			src.visible_message("<span style=\"color:red\"><B>[user] swings at [src] with the [W.name]!</B></span>")
			playsound(src.loc, "sound/weapons/punchmiss.ogg", 50, 1)
			sleep(2)
			shinobi_parry(user, W)
			return
		..()
		return

	proc/shinobi_parry(mob/M, obj/item/W)
		if (M)
			src.dir = get_dir(src, M)
			if (W)
				src.visible_message("<span style=\"color:red\"><B>[src] deflects the [W.name]!</B></span>")
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 65, 1)
			else
				src.visible_message("<span style=\"color:red\"><B>[src] parries [M]'s attack, throwing them to the ground!</B></span>")
				M.weakened = max(10, M.weakened)
				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 65, 1)
		return

	verb/shinobi_alert()
		set name = "Stance - Alert"
		set desc = "Take a defensive stance and deflect any attackers"
		set category = "Shinobi Stance"
		if (!src.stat && !src.transforming)
			src.stance = "defensive"

	verb/shinobi_relaxed()
		set name = "Stance - Relaxed"
		set desc = "Take a relaxed stance and cease your defense."
		set category = "Shinobi Stance"
		if (!src.stat && !src.transforming)
			src.stance = "normal"
