extends Label


func _process(delta: float) -> void:
	if Global.Start_Tutorial == true:
		visible = true
		Global.is_in_game = false
		text = "Welcome To System Killer! It's A Bullet Hell Rogue-Like. Use W S A D to 
		Move, Left Click To Shoot And Space To Dash.
		On Your Right Corner You Have Anti-Mattery or 
		Money In This World, On Your Left Corner You Have Health
		And Stamina"
		Global.Start_Tutorial = false
	if Global.Pierwszy_Pokój == true and Global.Show_Pierwszy_Pokój == true:
		visible = true
		Global.is_in_game = false
		text = "This Is The Kill Room, Here Enemys Will Spawn.
		You Will Also Encounter Power Up's That Can Either 
		Strenghen Or Weaken Your Character"
		Global.Pierwszy_Pokój = false
		Global.Show_Pierwszy_Pokój = false
	if Global.Unstable_World == true and Global.Show_Unstable_World == true:
		visible = true
		Global.is_in_game = false
		text = "The System Is Very Unstable Which Results In Various World Effects,
		Be Careful Of Them, As They Can Cause Harm"
		Global.Unstable_World = false
		Global.Show_Unstable_World = false
	if Global.Shop1 == true and Global.Show_Shop1 == true:
		visible = true
		Global.is_in_game = false
		text = "This Is An Upgrade Shoop Which Increases Your Stats"
		Global.Shop1 = false
		Global.Show_Shop1 = false
	if Global.Shopkeeper == true and Global.Show_Shopkeeper == true:
		visible = true
		Global.is_in_game = false
		text = "In This Shop You Can Buy Items Such As Weapons, Active Items and Passive Items
		You Can Only Have One Weapon And One Active Item, However You Can Have As Much Passive Items 
		As You Desire, You Can Activate Active Items By Pressing R"
		Global.Shopkeeper = false
		Global.Show_Shopkeeper = false
		

func _on_button_pressed() -> void:
	visible = false
	Global.is_in_game = true
