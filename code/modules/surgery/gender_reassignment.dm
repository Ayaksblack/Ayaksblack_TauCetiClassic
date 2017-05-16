//////////////////////////////////////////////////////////////////
//						Gender Reassignment						//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/gender_reassignment/
	priority = 2
	can_infect = 0
	blood_level = 1
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!ishuman(target))
			return 0
		if (target_zone != BP_GROIN)
			return 0
		var/obj/item/organ/external/groin = target.get_bodypart(BP_GROIN)
		if (!groin)
			return 0
		if (groin.open < 1)
			return 0
		return 1

/datum/surgery_step/gender_reassignment/reshape_genitals
	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,		\
	/obj/item/weapon/kitchenknife = 75,	\
	/obj/item/weapon/shard = 50, 		\
	)

	min_duration = 110
	max_duration = 150

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(!ishuman(target))	return 0
		var/obj/item/organ/external/BP = target.get_bodypart(target_zone)
		return ..() && BP.open == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(target.gender == FEMALE)
			user.visible_message("[user] begins to reshape [target]'s genitals to look more masculine with \the [tool].", \
			"You start to reshape [target]'s genitals to look more masculine with \the [tool]." )
		else
			user.visible_message("[user] begins to reshape [target]'s genitals to look more feminine with \the [tool].", \
			"You start to reshape [target]'s genitals to look more feminine with \the [tool]." )
		target.custom_pain("The pain in your groin is living hell!",1)
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(target.gender == FEMALE)
			user.visible_message("\blue [user] has made a man of [target] with \the [tool]." , \
			"\blue You have made a man of [target].")
			target.gender = MALE
		else
			user.visible_message("\blue [user] has made a woman of [target] with \the [tool]." , \
			"\blue You have made a woman of [target].")
			target.gender = FEMALE

		target.regenerate_icons()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/BP = target.bodyparts_by_name[BP_GROIN]
		user.visible_message("\red [user]'s hand slips, slicing [target]'s genitals with \the [tool]!", \
		"\red Your hand slips, slicing [target]'s genitals with \the [tool]!")
		BP.createwound(CUT, 20, 1)
