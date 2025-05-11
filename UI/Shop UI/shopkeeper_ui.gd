extends Control

@export var Player: CharacterBody2D

@onready var weapon_texture: TextureRect = $HBoxContainer/VBoxContainer/Weapon_Texture
@onready var weapon_button: TextureButton = $HBoxContainer/VBoxContainer/Weapon_Button

@onready var aktywny_itemek_texture: TextureRect = $HBoxContainer/VBoxContainer2/Aktywny_Itemek_Texture
@onready var aktywny_itemek_button: TextureButton = $HBoxContainer/VBoxContainer2/Aktywny_Itemek_Button

@onready var pasywny_itemek_1_texture: TextureRect = $HBoxContainer/VBoxContainer3/Pasywny_Itemek1_Texture
@onready var pasywny_itemek_1_button: TextureButton = $HBoxContainer/VBoxContainer3/Pasywny_Itemek1_Button

@onready var pasywny_itemek_2_texture: TextureRect = $HBoxContainer/VBoxContainer4/Pasywny_Itemek2_Texture
@onready var pasywny_itemek_2_button: TextureButton = $HBoxContainer/VBoxContainer4/Pasywny_Itemek2_Button

@onready var reset_button: Button = $Reset_Button

class AktywnyItemek:
	var Player: CharacterBody2D
	var integer: int

	var Lista_Aktywnych_Itemków = {}
	var Lista_Textur = {}
	var Opisy = {
		1: "Creates A Shield Around You For 5 Seconds That Stops All Bullets Coming Your Way",
		2: "Creates A Homing Missile For Every Enemy In Large Area Around You",
		3: "Creates A Small Shockwave Around You That Kills Every Enemy And Destroys Every Bullet",
		4: "Clear Every Enemy Bullet In The Map",
		5: "Creates A Lighting Storm In Your Mouse's Place"
	}
	var Ceny = {
		1: 10,
		2: 20,
		3: 20,
		4: 20,
		5: 20
	}
	
	var dojscie
	var opis
	var cena
	var lenght
	var textura

	func _init(p, i):
		Player = p
		integer = i
		Lista_Aktywnych_Itemków = {
			1: "1",
			2: "2",
			3: "3",
			4: "4",
			5: "5"
		}
		Lista_Textur = {
			2: preload("res://Art/itemy/namierzanie.png"),
			5: preload("res://Art/itemy/burza.png"),
			3: preload("res://Art/itemy/AOE.png"),
			4: preload("res://Art/itemy/usuwanie.png"),
			1: preload("res://Art/itemy/tarcza.png")
		}
		dojscie = Lista_Aktywnych_Itemków[integer]
		opis = Opisy[integer]
		cena = Ceny[integer]
		lenght = Ceny.size()
		textura = Lista_Textur[integer]


class PasywnyItemek:
	var Player: CharacterBody2D
	var integer: int

	var Lista_Pasywnych_Itemków = {}
	var Lista_Textur = {}
	var Opisy = {
		1: "Your Bullets Fly Faster",
		2: "You Have 25% Chance To Not Take Damage After You Get Hit",
		3: "Every Time You Shoot, You Have 25% Chance To Fire A Lighting In Random Direction",
		4: "Every Time You Walk You Leave A Trace Behind That Kills Enemys",
		5: "3 Orbitals That Fly Around Your Character Killing Both Enemys And Bullets That Stand In Their Way",
		6: "Your Bullets Can Pierce Through One Enemy",
		7: "Your Health Slowly Regenerates",
		8: "You Gain Additional Special Heart That Regenerates Quite Fast",
		9: "Your Bullets Can Fly Through Inner Walls"
	}
	var Ceny = {
		1: 10,
		2: 20,
		3: 20,
		4: 20,
		5: 20,
		6: 20,
		7: 20,
		8: 20,
		9: 10
	}

	var dojscie
	var opis
	var cena
	var lenght
	var textura

	func _init(p, i):
		Player = p
		integer = i
		Lista_Pasywnych_Itemków = {
			1: "1",
			2: "2",
			3: "3",
			4: "4",
			5: "5",
			6: "6",
			7: "7",
			8: "8",
			9: "9"
		}
		Lista_Textur = {
			8: preload("res://Art/itemy/dodawanie_serca.png"),
			1: preload("res://Art/itemy/szybsze_pociski.png"),
			4: preload("res://Art/itemy/scieżka.png"),
			6: preload("res://Art/itemy/przebijanie.png"),
			3: preload("res://Art/itemy/piorun.png"),
			5: preload("res://Art/itemy/orbitable.png"),
			7: preload("res://Art/itemy/regeneracja.png"),
			2: preload("res://Art/itemy/25%redu.png"),
			9: preload("res://Art/itemy/przebijanie.png")
		}
		dojscie = Lista_Pasywnych_Itemków[integer]
		opis = Opisy[integer]
		cena = Ceny[integer]
		lenght = Ceny.size()
		textura = Lista_Textur[integer]

class Bron:
	var Player: CharacterBody2D
	var integer: int
	
	var Lista_Textur = {}
	var Lista_Broni = {
		1: "Karabin",
		2: "Uzi",
		3: "Minigun",
		4: "Shotgun"
	}
	var Opisy = {
		1: "Automatic Rifle, Bad Damage and Decent Attack Speed",
		2: "Submachine Gun, Fires in Bursts, Very Good Dmg but Very Bad Attack Speed",
		3: "Minigun, Very High Attack Speed but Low Damage and Quite Innacurate",
		4: "Shotgun, Fires a Bunch of Bullets at Once, Good Damage but Bad Attack Speed"
	}
	var Ceny = {
		1: 10,
		2: 10,
		3: 10,
		4: 10
	}
	
	var dojscie
	var funkcja
	var Nazwa
	var opis
	var cena
	var lenght
	var textura

	func _init(p, i):
		Player = p
		integer = i
		Nazwa = Lista_Broni[integer]
		opis = Opisy[integer]
		cena = Ceny[integer]
		lenght = Ceny.size()
		Lista_Textur = {
			1: preload("res://Art/itemy/kałach.png"),
			2: preload("res://Art/itemy/pm.png"),
			3: preload("res://Art/itemy/minigun.png"),
			4: preload("res://Art/itemy/Strzelba.png")
		}
		textura = Lista_Textur[integer]

#Zmienne pokazujące co jest w sklepie
var Bron_Nazwa
var Bron_Dojscie
var Bron_Aktywacja
var Bron_Cena
var Bron_Opis

var Bron_Textura


var Aktywny_Itemek
var Aktywny_Itemek_Cena
var Aktywny_Itemek_Opis

var Aktywny_Itemek_Textura
var rand3 

var Pasywny_Itemek1
var Pasywny_Itemek1_Cena
var Pasywny_Itemek1_Opis

var Pasywny_Itemek1_Textura
var rand1

var Pasywny_Itemek2
var Pasywny_Itemek2_Cena
var Pasywny_Itemek2_Opis

var Pasywny_Itemek2_Textura
var rand2

func _ready():
	visible = false
	Zmiana_Sklepu()

func _process(delta: float) -> void:
	if Global.shopkeeper_ui_visible == true:
		visible = true
		
	else:
		visible = false
	
	if Bron_Cena > Global.VDolce:
		weapon_button.disabled = true
		weapon_button.tooltip_text = str(Bron_Cena) + "$ " + "Not Enough Money"  
	else:
		weapon_button.disabled = false
		weapon_button.tooltip_text = str(Bron_Cena) + "$ "
		
	if Aktywny_Itemek_Cena > Global.VDolce:
		aktywny_itemek_button.disabled = true
		aktywny_itemek_texture.tooltip_text = str(Aktywny_Itemek_Cena) + "$ " + "Not Enough Money"
	else:
		aktywny_itemek_button.disabled = false
		aktywny_itemek_texture.tooltip_text = str(Aktywny_Itemek_Cena) + "$ "
		
	if Pasywny_Itemek1_Cena > Global.VDolce:
		pasywny_itemek_1_button.disabled = true
		pasywny_itemek_1_texture.tooltip_text = str(Pasywny_Itemek1_Cena) + "$ " + "Not Enough Money"
	else:
		pasywny_itemek_1_button.disabled = false
		pasywny_itemek_1_texture.tooltip_text = str(Pasywny_Itemek1_Cena) + "$ "
		
	if Pasywny_Itemek2_Cena > Global.VDolce:
		pasywny_itemek_2_button.disabled = true
		pasywny_itemek_2_texture.tooltip_text = str(Pasywny_Itemek2_Cena) + "$ " + "Not Enough Money"
	else:
		pasywny_itemek_2_button.disabled = false
		pasywny_itemek_2_texture.tooltip_text = str(Pasywny_Itemek2_Cena) + "$ "
		
	if 5 > Global.VDolce:
		reset_button.disabled = true
		reset_button.tooltip_text = "5$ " + "Not Enough Money"
	else:
		reset_button.disabled = false
		reset_button.tooltip_text = "5$ "

func Zmiana_Sklepu():
	#Pasywny Itemek 1
	rand1 = randi_range(1,4)
	var pasywny1 = PasywnyItemek.new(Player,rand1)
	Pasywny_Itemek1 = pasywny1.dojscie
	Pasywny_Itemek1_Cena = pasywny1.cena
	Pasywny_Itemek1_Opis = pasywny1.opis
	Pasywny_Itemek1_Textura = pasywny1.textura
	var passive_image_1 = Pasywny_Itemek1_Textura.get_image()
	passive_image_1.resize(128, 128, Image.INTERPOLATE_NEAREST)
	pasywny_itemek_1_texture.texture = ImageTexture.create_from_image(passive_image_1)
	pasywny_itemek_1_texture.texture_filter = 1
	pasywny_itemek_1_texture.tooltip_text = Pasywny_Itemek1_Opis
	pasywny_itemek_1_button.tooltip_text = str(Pasywny_Itemek1_Cena) + " $"
	
	#Pasywny Itemek2
	rand2 = randi_range(5,9)
	if rand2 == rand1:
		if rand2 == 8:
			rand2 -= 1
		else:
			rand2 += 1
	var pasywny2 = PasywnyItemek.new(Player,rand2)
	Pasywny_Itemek2 = pasywny2.dojscie
	Pasywny_Itemek2_Cena = pasywny2.cena
	Pasywny_Itemek2_Opis = pasywny2.opis
	Pasywny_Itemek2_Textura = pasywny2.textura
	var passive_image_2 = Pasywny_Itemek2_Textura.get_image()
	passive_image_2.resize(128, 128, Image.INTERPOLATE_NEAREST)
	pasywny_itemek_2_texture.texture = ImageTexture.create_from_image(passive_image_2)
	pasywny_itemek_2_texture.texture_filter = 1
	pasywny_itemek_2_texture.tooltip_text = Pasywny_Itemek2_Opis
	pasywny_itemek_2_button.tooltip_text = str(Pasywny_Itemek2_Cena) + " $"
	
	#Aktywny Itemek
	rand3 = randi_range(1,5)
	var aktywny = AktywnyItemek.new(Player,rand3)
	Aktywny_Itemek = aktywny.dojscie
	Aktywny_Itemek_Cena = aktywny.cena
	Aktywny_Itemek_Opis = aktywny.opis
	Aktywny_Itemek_Textura = aktywny.textura
	var active_image = Aktywny_Itemek_Textura.get_image()
	active_image.resize(128, 128, Image.INTERPOLATE_NEAREST)
	aktywny_itemek_texture.texture = ImageTexture.create_from_image(active_image)
	aktywny_itemek_texture.texture_filter = 1
	aktywny_itemek_texture.tooltip_text = Aktywny_Itemek_Opis
	aktywny_itemek_button.tooltip_text = str(Aktywny_Itemek_Cena) + " $"
	
	#Bron
	var rand4 = randi_range(1,4)
	var bron = Bron.new(Player,rand4)
	Bron_Nazwa = bron.Nazwa
	Bron_Cena = bron.cena
	Bron_Opis = bron.opis
	Bron_Textura = bron.textura
	var bron_image = Bron_Textura.get_image()
	bron_image.resize(128, 128, Image.INTERPOLATE_NEAREST)
	weapon_texture.texture = ImageTexture.create_from_image(bron_image)
	weapon_texture.texture_filter = 1
	weapon_texture.tooltip_text = Bron_Opis
	weapon_button.tooltip_text = str(Bron_Cena) + " $"


func _on_weapon_button_pressed() -> void:
	var x = randi_range(0, 1)
	match(x):
		0:
			AudioManager.buy_1.play()
		1:
			AudioManager.buy_2.play()
	
	if Global.VDolce >= Bron_Cena and Global.CurrentWeapon != Bron_Nazwa:
		Global.VDolce -= Bron_Cena
		Global.CurrentWeapon = Bron_Nazwa
		Player._on_weapon_changed()
		


func _on_aktywny_itemek_button_pressed() -> void:
	var x = randi_range(0, 1)
	match(x):
		0:
			AudioManager.buy_1.play()
		1:
			AudioManager.buy_2.play()
	
	if Global.VDolce >= Aktywny_Itemek_Cena and rand3-1 != Player.Current_Active_Item:
		Global.VDolce -= Aktywny_Itemek_Cena
		Player.Can_Use_Tarcza = false
		Player.Can_Use_Projectiles = false
		Player.Can_Use_AOE = false
		Player.Can_Use_Clear = false
		Player.Can_Use_Pioruny = false
		match(Aktywny_Itemek):
			"1":
				Player.Can_Use_Tarcza = true
				Player.Current_Active_Item = 0
			"2":
				Player.Can_Use_Projectiles = true
				Player.Current_Active_Item = 1
			"3":
				Player.Can_Use_AOE = true
				Player.Current_Active_Item = 2
			"4":
				Player.Can_Use_Clear = true
				Player.Current_Active_Item = 3
			"5":
				Player.Can_Use_Pioruny = true
				Player.Current_Active_Item = 4
		


func _on_pasywny_itemek_1_button_pressed() -> void:
	var x = randi_range(0, 1)
	match(x):
		0:
			AudioManager.buy_1.play()
		1:
			AudioManager.buy_2.play()
	
	if Global.VDolce >= Pasywny_Itemek1_Cena:
		Global.VDolce -= Pasywny_Itemek1_Cena
		match(Pasywny_Itemek1):
			"1":
				Player.faster_bullets = true
			"2":
				Player.immunity_chance = true
			"3":
				Player.Piorun = true
			"4":
				Player.Trace = true
			"5":
				Player.Orbitale = true
			"6":
				Player.Bullet_Piercing_Pasywny = true
			"7":
				Player.Regenerating_Health = true
			"8":
				Player.Regenerating_Heart = true
			"9":
				Player.Ignore_wall_Item = true
				


func _on_pasywny_itemek_2_button_pressed() -> void:
	var x = randi_range(0, 1)
	match(x):
		0:
			AudioManager.buy_1.play()
		1:
			AudioManager.buy_2.play()
	
	if Global.VDolce >= Pasywny_Itemek2_Cena:
		Global.VDolce -= Pasywny_Itemek2_Cena
		match(Pasywny_Itemek2):
			"1":
				Player.faster_bullets = true
			"2":
				Player.immunity_chance = true
			"3":
				Player.Piorun = true
			"4":
				Player.Trace = true
			"5":
				Player.Orbitale = true
			"6":
				Player.Bullet_Piercing_Pasywny = true
			"7":
				Player.Regenerating_Health = true
			"8":
				Player.Regenerating_Heart = true
			"9":
				Player.Ignore_wall_Item = true


func _on_reset_button_pressed() -> void:
	if Global.VDolce > 5:
		Global.VDolce -= 5
		Zmiana_Sklepu()
