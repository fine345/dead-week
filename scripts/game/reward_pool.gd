extends Node

const REWARD_DEFS := [
	{
		"id": "bullet_damage",
		"title": "子弹伤害 +50%",
		"type": "attribute",
		"max_count": 5
	},
	{
		"id": "pickup_range",
		"title": "拾取范围 +75%",
		"type": "attribute",
		"max_count": 2
	},
	{
		"id": "attack_speed",
		"title": "攻速 +50%",
		"type": "attribute",
		"max_count": 2
	},
	{
		"id": "bullet_count",
		"title": "子弹数量 +1",
		"type": "attribute",
		"max_count": 3
	},
	{
		"id": "experience_bonus",
		"title": "经验球经验 +50%",
		"type": "attribute",
		"max_count": 2
	},
	{
		"id": "shield",
		"title": "护盾（抵挡1次攻击）",
		"type": "ability"
	},
	{
		"id": "freeze_chance",
		"title": "子弹概率冰冻敌人",
		"type": "ability",
		"max_count": 1
	},
	{
		"id": "burn_chance",
		"title": "子弹概率点燃敌人",
		"type": "ability",
		"max_count": 1
	},
	{
		"id": "bounce_count",
		"title": "子弹弹射 +1",
		"type": "ability",
		"max_count": 2
	},
	{
		"id": "knockback",
		"title": "子弹获得击退效果",
		"type": "ability",
		"max_count": 1
	},
	{
		"id": "attack_range",
		"title": "攻击范围 +50%",
		"type": "attribute",
		"max_count": 2
	},
	{
		"id": "bullet_speed",
		"title": "子弹速度 +50%",
		"type": "attribute",
		"max_count": 2
	}
]

func get_offer_choices(existing_counts: Dictionary, offer_count: int = 3, player_shield_count: int = 0) -> Array[Dictionary]:
	var available: Array[Dictionary] = []
	for reward in REWARD_DEFS:
		var reward_id: String = str(reward["id"])
		var current_count: int = int(existing_counts.get(reward_id, 0))
		var max_count: int = int(reward["max_count"]) if reward.has("max_count") else 999999
		var repeatable: bool = reward.has("repeatable") and bool(reward["repeatable"])
		if reward_id == "shield":
			if player_shield_count > 0:
				continue
			available.append(reward)
		elif repeatable:
			if current_count < max_count:
				available.append(reward)
		elif current_count < max_count:
			available.append(reward)

	var choices: Array[Dictionary] = []
	var pool: Array[Dictionary] = available.duplicate()
	while choices.size() < offer_count and pool.size() > 0:
		var index: int = randi() % pool.size()
		choices.append(pool[index])
		pool.remove_at(index)
	return choices

func get_reward_title(reward_id: String) -> String:
	for reward in REWARD_DEFS:
		if reward.id == reward_id:
			return str(reward.title)
	return reward_id

func get_reward_type(reward_id: String) -> String:
	for reward in REWARD_DEFS:
		if reward.id == reward_id:
			return str(reward.type)
	return "attribute"
