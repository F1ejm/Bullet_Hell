extends Node

#Player Speed
var speed: int = 600
var stop: bool = false

#Interaction
var show_interaction: bool = false

#Shop
var shop_can_interact: bool = false
var shop_ui_visible: bool = false

#Życie
var Zycie: int = 3
var Max_Zycie: int = 3

#Stamina
var Stamina: float = 200
var Max_Stamina: float = 200
var Stamina_Regen: float = 1
var Dash: bool = false

#Dash
var IsDashing: bool
var dash_timer: float = 0
var Koszt_Dasha: int = 80
