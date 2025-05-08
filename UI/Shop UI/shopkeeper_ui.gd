extends Control

@export var Player: CharacterBody2D

@onready var weapon_texture: TextureRect = $HBoxContainer/VBoxContainer/Weapon_Texture
@onready var weapon_button: Button = $HBoxContainer/VBoxContainer/Weapon_Button

@onready var aktywny_itemek_texture: TextureRect = $HBoxContainer/VBoxContainer2/Aktywny_Itemek_Texture
@onready var aktywny_itemek_button: Button = $HBoxContainer/VBoxContainer2/Aktywny_Itemek_Button

@onready var pasywny_itemek_1_texture: TextureRect = $HBoxContainer/VBoxContainer3/Pasywny_Itemek1_Texture
@onready var pasywny_itemek_1_button: Button = $HBoxContainer/VBoxContainer3/Pasywny_Itemek1_Button

@onready var pasywny_itemek_2_texture: TextureRect = $HBoxContainer/VBoxContainer4/Pasywny_Itemek2_Texture
@onready var pasywny_itemek_2_button: Button = $HBoxContainer/VBoxContainer4/Pasywny_Itemek2_Button

class AktywnyItemek:
	var Player: CharacterBody2D
	var integer: int

	var Lista_Aktywnych_Itemków = {}
	var Lista_Textur = {}
	var Opisy = {
		1: "Opis1",
		2: "Opis2",
		3: "Opis3",
		4: "Opis4",
		5: "Opis5"
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
			4: preload("res://Art/itemy/orbitable.png"),
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
		1: "Opis1",
		2: "Opis2",
		3: "Opis3",
		4: "Opis4",
		5: "Opis5",
		6: "Opis6",
		7: "Opis7",
		8: "Opis8"
	}
	var Ceny = {
		1: 10,
		2: 20,
		3: 20,
		4: 20,
		5: 20,
		6: 20,
		7: 20,
		8: 20
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
			8: "8"
		}
		Lista_Textur = {
			8: preload("res://Art/itemy/dodawanie_serca.png"),
			1: preload("res://Art/itemy/szybsze_pociski.png"),
			4: preload("res://Art/itemy/scieżka.png"),
			6: preload("res://Art/itemy/przebijanie.png"),
			3: preload("res://Art/itemy/piorun.png"),
			5: preload("res://Art/itemy/orbitable.png"),
			7: preload("res://Art/itemy/regeneracja.png"),
			2: preload("res://Art/itemy/25%redu.png")
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
		2: "Pistol",
		3: "Uzi",
		4: "Minigun",
		5: "Shotgun"
	}
	var Opisy = {
		1: "opis1",
		2: "opis2",
		3: "opis3",
		4: "opis4",
		5: "opis5"
	}
	var Ceny = {
		1: 10,
		2: 10,
		3: 10,
		4: 10,
		5: 10
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
			1: preload("res://Art/Maro/Maro_ZdjęcieOG.png"),
			2: preload("res://Art/itemy/pistol.png"),
			3: preload("res://Art/itemy/pm.png"),
			4: preload("res://Art/itemy/minigun.png"),
			5: preload("res://Art/itemy/Strzelba.png")
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


var Pasywny_Itemek1
var Pasywny_Itemek1_Cena
var Pasywny_Itemek1_Opis

var Pasywny_Itemek1_Textura

var Pasywny_Itemek2
var Pasywny_Itemek2_Cena
var Pasywny_Itemek2_Opis

var Pasywny_Itemek2_Textura

func _ready():
	visible = false
	Zmiana_Sklepu()

func _process(delta: float) -> void:
	if Global.shopkeeper_ui_visible == true:
		visible = true
		
	else:
		visible = false

func Zmiana_Sklepu():
	#Pasywny Itemek 1
	var rand1 = randi_range(1,4)
	var pasywny1 = PasywnyItemek.new(Player,rand1)
	Pasywny_Itemek1 = pasywny1.dojscie
	Pasywny_Itemek1_Cena = pasywny1.cena
	Pasywny_Itemek1_Opis = pasywny1.opis
	Pasywny_Itemek1_Textura = pasywny1.textura
	pasywny_itemek_1_texture.texture = Pasywny_Itemek1_Textura
	pasywny_itemek_1_texture.tooltip_text = Pasywny_Itemek1_Opis
	pasywny_itemek_1_button.tooltip_text = str(Pasywny_Itemek1_Cena)
	
	#Pasywny Itemek2
	var rand2 = randi_range(5,8)
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
	pasywny_itemek_2_texture.texture = Pasywny_Itemek2_Textura
	pasywny_itemek_2_texture.tooltip_text = Pasywny_Itemek2_Opis
	pasywny_itemek_2_button.tooltip_text = str(Pasywny_Itemek2_Cena)
	
	#Aktywny Itemek
	var rand3 = randi_range(1,5)
	var aktywny = AktywnyItemek.new(Player,rand3)
	Aktywny_Itemek = aktywny.dojscie
	Aktywny_Itemek_Cena = aktywny.cena
	Aktywny_Itemek_Opis = aktywny.opis
	Aktywny_Itemek_Textura = aktywny.textura
	aktywny_itemek_texture.texture = Aktywny_Itemek_Textura
	aktywny_itemek_texture.tooltip_text = Aktywny_Itemek_Opis
	aktywny_itemek_button.tooltip_text = str(Aktywny_Itemek_Cena)
	
	#Bron
	var rand4 = randi_range(1,5)
	var bron = Bron.new(Player,rand4)
	Bron_Nazwa = bron.Nazwa
	Bron_Cena = bron.cena
	Bron_Opis = bron.opis
	Bron_Textura = bron.textura
	weapon_texture.texture = Bron_Textura
	weapon_texture.tooltip_text = Bron_Opis
	weapon_button.tooltip_text = str(Bron_Cena)


func _on_weapon_button_pressed() -> void:
	if Global.VDolce >= Bron_Cena:
		Global.VDolce -= Bron_Cena
		Global.CurrentWeapon = Bron_Nazwa
		Player._on_weapon_changed()
		


func _on_aktywny_itemek_button_pressed() -> void:
	if Global.VDolce >= Aktywny_Itemek_Cena:
		print(Aktywny_Itemek_Opis)
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
	if Global.VDolce >= Pasywny_Itemek1_Cena:
		print(Pasywny_Itemek1_Opis)
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
				


func _on_pasywny_itemek_2_button_pressed() -> void:
	if Global.VDolce >= Pasywny_Itemek2_Cena:
		print(Pasywny_Itemek2_Opis)
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
