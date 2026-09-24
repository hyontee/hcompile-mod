stock get_skin_name ( modelid )
{
    new model_name [ 42 ] ;
	switch ( modelid )
	{
	    case 0: strcat ( model_name, "Carl 'CJ' Johnson" ) ; 
	    case 1: strcat ( model_name, "The Truth" ) ; // магаз скинов
	    case 2: strcat ( model_name, "Maccer" ) ; // магаз скинов
	    case 3: strcat ( model_name, "Andre" ) ; // магаз скинов
	    case 4: strcat ( model_name, "Barry 'Big Bear' Thorne" ) ; // магаз скинов 
	    case 5: strcat ( model_name, "Barry 'Big Bear' Thorne" ) ; // магаз скинов
	    case 6: strcat ( model_name, "Emmet" ) ; // магаз скинов
	    case 7: strcat ( model_name, "Taxi Driver" ) ; // магаз скинов
	    case 8: strcat ( model_name, "Janitor" ) ;
	    case 9: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 10: strcat ( model_name, "Old Woman" ) ; // донат + craft
	    case 11: strcat ( model_name, "Casino Croupier" ) ;
	    case 12: strcat ( model_name, "Rich Woman" ) ; // магаз скинов
	    case 13: strcat ( model_name, "Street Girl" ) ;
	    case 14: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 15: strcat ( model_name, "Mr. Whittaker" ) ; // магаз скинов
	    case 16: strcat ( model_name, "Airport Ground Worker" ) ;
	    case 17: strcat ( model_name, "Businessman" ) ;
	    case 18: strcat ( model_name, "Beach Visitor" ) ; // магаз скинов
	    case 19: strcat ( model_name, "DJ" ) ; // магаз скинов
	    case 20: strcat ( model_name, "Rich Guy" ) ;
	    case 21: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 22: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 23: strcat ( model_name, "BMXer" ) ; // магаз скинов
	    case 24: strcat ( model_name, "Madd Dogg Bodyguard" ) ; // магаз скинов
	    case 25: strcat ( model_name, "Madd Dogg Bodyguard" ) ; // магаз скинов
	    case 26: strcat ( model_name, "Backpacker" ) ; // магаз скинов
	    case 27: strcat ( model_name, "Construction Worker" ) ;
	    case 28: strcat ( model_name, "Drug Dealer" ) ; // магаз скинов
	    case 29: strcat ( model_name, "Drug Dealer" ) ; // магаз скинов
	    case 30: strcat ( model_name, "Drug Dealer" ) ; // магаз скинов
	    case 31: strcat ( model_name, "Farm-Town inhabitant" ) ; // магаз скинов
	    case 32: strcat ( model_name, "Farm-Town inhabitant" ) ;
	    case 33: strcat ( model_name, "Farm-Town inhabitant" ) ; // донат
	    case 34: strcat ( model_name, "Farm-Town inhabitant" ) ;
	    case 35: strcat ( model_name, "Gardener" ) ;
	    case 36: strcat ( model_name, "Golfer" ) ;
	    case 37: strcat ( model_name, "Golfer" ) ;
	    case 38: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 39: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 40: strcat ( model_name, "Normal Ped" ) ;
	    case 41: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 42: strcat ( model_name, "Jethro" ) ;
	    case 43: strcat ( model_name, "Normal Ped" ) ; // craft
	    case 44: strcat ( model_name, "Normal Ped" ) ;
	    case 45: strcat ( model_name, "Beach Visitor" ) ; // донат
	    case 46: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 47: strcat ( model_name, "Normal Ped" ) ; // донат
	    case 48: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 49: strcat ( model_name, "Snakehead" ) ; // магаз скинов
	    case 50: strcat ( model_name, "Mechanic" ) ;
	    case 51: strcat ( model_name, "Mountain Biker" ) ;
	    case 52: strcat ( model_name, "Mountain Biker" ) ; // магаз скинов
	    case 53: strcat ( model_name, "Unknown" ) ; // магаз скинов
	    case 54: strcat ( model_name, "Normal Ped" ) ;
	    case 55: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 56: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 57: strcat ( model_name, "Oriental Ped" ) ; // магаз скинов
	    case 58: strcat ( model_name, "Oriental Ped" ) ; // магаз скинов
	    case 59: strcat ( model_name, "Normal Ped" ) ;
	    case 60: strcat ( model_name, "Normal Ped" ) ;
	    case 61: strcat ( model_name, "Pilot" ) ;
	    case 62: strcat ( model_name, "Colonel Fuhrberger" ) ; // магаз скинов
	    case 63: strcat ( model_name, "Prostitute" ) ;
	    case 64: strcat ( model_name, "Prostitute" ) ; // донат
	    case 65: strcat ( model_name, "Kendl Johnson" ) ; // магаз скинов
	    case 66: strcat ( model_name, "Pool Player" ) ; 
	    case 67: strcat ( model_name, "Pool Player" ) ;
	    case 68: strcat ( model_name, "Priest" ) ;
	    case 69: strcat ( model_name, "Normal Ped" ) ;
	    case 70: strcat ( model_name, "Scientist" ) ;
	    case 71: strcat ( model_name, "Security Guard" ) ;
	    case 72: strcat ( model_name, "Hippy" ) ;
	    case 73: strcat ( model_name, "Hippy" ) ;
	    case 74: strcat ( model_name, "-" ) ;
	    case 75: strcat ( model_name, "Prostitute" ) ;
	    case 76: strcat ( model_name, "Stewardess" ) ;
	    case 77: strcat ( model_name, "Homeless" ) ; // донат
	    case 78: strcat ( model_name, "Homeless" ) ; // магаз скинов
	    case 79: strcat ( model_name, "Homeless" ) ; // магаз скинов
	    case 80: strcat ( model_name, "Boxer" ) ;
	    case 81: strcat ( model_name, "Boxer" ) ;
	    case 82: strcat ( model_name, "Black Elvis" ) ; // магаз скинов
	    case 83: strcat ( model_name, "White Elvis" ) ;
	    case 84: strcat ( model_name, "Blue Elvis" ) ; // донат
	    case 85: strcat ( model_name, "Prostitute" ) ; // магаз скинов
	    case 86: strcat ( model_name, "Ryder with robbery mask" ) ;
	    case 87: strcat ( model_name, "Stripper" ) ;
	    case 88: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
		case 89: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
		case 90: strcat ( model_name, "Jogger" ) ; // магаз скинов
		case 91: strcat ( model_name, "Rich Woman" ) ; // магаз скинов
		case 92: strcat ( model_name, "Rollerskater" ) ;
		case 93: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
		case 94: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
		case 95: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
		case 96: strcat ( model_name, "Jogger" ) ;
		case 97: strcat ( model_name, "Lifeguard" ) ; // магаз скинов
		case 98: strcat ( model_name, "Normal Ped" ) ;
		case 99: strcat ( model_name, "Rollerskater" ) ;
		case 100: strcat ( model_name, "Biker" ) ; // магаз скинов
		case 101: strcat ( model_name, "Normal Ped" ) ;
		case 102: strcat ( model_name, "Ballas" ) ;
		case 103: strcat ( model_name, "Ballas" ) ; // магаз скинов
		case 104: strcat ( model_name, "Ballas" ) ;
		case 105: strcat ( model_name, "Grove Street Families" ) ; // донат
		case 106: strcat ( model_name, "Grove Street Families" ) ; // донат
		case 107: strcat ( model_name, "Grove Street Families" ) ;
		case 108: strcat ( model_name, "Los Santos Vagos" ) ;
	    case 109: strcat ( model_name, "Los Santos Vagos" ) ; // донат
	    case 110: strcat ( model_name, "Los Santos Vagos" ) ; // донат
	    case 111: strcat ( model_name, "The Russian Mafia" ) ;
	    case 112: strcat ( model_name, "The Russian Mafia" ) ;
	    case 113: strcat ( model_name, "The Russian Mafia" ) ;
	    case 114: strcat ( model_name, "Varios Los Aztecas" ) ;
	    case 115: strcat ( model_name, "Varios Los Aztecas" ) ;
	    case 116: strcat ( model_name, "Varios Los Aztecas" ) ;
	    case 117: strcat ( model_name, "Triad" ) ;
	    case 118: strcat ( model_name, "Triad" ) ; // донат
	    case 119: strcat ( model_name, "Johhny Sindacco" ) ; // магаз скинов
	    case 120: strcat ( model_name, "Triad Boss" ) ;
	    case 121: strcat ( model_name, "Da Nang Boy" ) ;
	    case 122: strcat ( model_name, "Da Nang Boy" ) ;
	    case 123: strcat ( model_name, "Da Nang Boy" ) ;
	    case 124: strcat ( model_name, "The Mafia" ) ;
	    case 125: strcat ( model_name, "The Mafia" ) ;
	    case 126: strcat ( model_name, "The Mafia" ) ; // магаз скинов
	    case 127: strcat ( model_name, "The Mafia" ) ;
	    case 128: strcat ( model_name, "Farm Inhabitant" ) ;
	    case 129: strcat ( model_name, "Farm Inhabitant" ) ; // магаз скинов
	    case 130: strcat ( model_name, "Farm Inhabitant" ) ; // донат
	    case 131: strcat ( model_name, "Farm Inhabitant" ) ; // магаз скинов
	    case 132: strcat ( model_name, "Farm Inhabitant" ) ;
	    case 133: strcat ( model_name, "Farm Inhabitant" ) ;
	    case 134: strcat ( model_name, "Homeless" ) ; // магаз скинов
	    case 135: strcat ( model_name, "Homeless" ) ; // магаз скинов
	    case 136: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 137: strcat ( model_name, "Homeless" ) ; // магаз скинов
	    case 138: strcat ( model_name, "Beach Visitor" ) ;
	    case 139: strcat ( model_name, "Beach Visitor" ) ; // донат + craft
	    case 140: strcat ( model_name, "Beach Visitor" ) ;
	    case 141: strcat ( model_name, "Businesswoman" ) ;
	    case 142: strcat ( model_name, "Taxi Driver" ) ; // магаз скинов
	    case 143: strcat ( model_name, "Crack Maker" ) ;
	    case 144: strcat ( model_name, "Crack Maker" ) ; // магаз скинов
	    case 145: strcat ( model_name, "Crack Maker" ) ; // донат
	    case 146: strcat ( model_name, "Crack Maker" ) ;
	    case 147: strcat ( model_name, "Businessman" ) ;
	    case 148: strcat ( model_name, "Businesswoman" ) ;
	    case 149: strcat ( model_name, "Big Smoke Armored" ) ;
	    case 150: strcat ( model_name, "Businesswoman" ) ;
	    case 151: strcat ( model_name, "Normal Ped" ) ;
	    case 152: strcat ( model_name, "Prostitute" ) ;
	    case 153: strcat ( model_name, "Construction Worker" ) ;
	    case 154: strcat ( model_name, "Beach Visitor" ) ;
	    case 155: strcat ( model_name, "Well Stacked Pizza Worker" ) ;
	    case 156: strcat ( model_name, "Barber" ) ;
	    case 157: strcat ( model_name, "Hillbilly" ) ;
	    case 158: strcat ( model_name, "Farmer" ) ;
	    case 159: strcat ( model_name, "Hillbilly" ) ;
	    case 160: strcat ( model_name, "Hillbilly" ) ; // магаз скинов
	    case 161: strcat ( model_name, "Farmer" ) ;
	    case 162: strcat ( model_name, "Hillbilly" ) ;
	    case 163: strcat ( model_name, "Black Bouncer" ) ;
	    case 164: strcat ( model_name, "White Bouncer" ) ;
	    case 165: strcat ( model_name, "White MIB agent" ) ;
	    case 166: strcat ( model_name, "Black MIB agent" ) ;
	    case 167: strcat ( model_name, "Cluckin' Bell Worker" ) ;
	    case 168: strcat ( model_name, "Chilli Dog Vendor" ) ;
	    case 169: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 170: strcat ( model_name, "Normal Ped" ) ;
	    case 171: strcat ( model_name, "Blackjack Dealer" ) ;
	    case 172: strcat ( model_name, "Casino Croupier" ) ;
	    case 173: strcat ( model_name, "San Fierro Rifa" ) ;
	    case 174: strcat ( model_name, "San Fierro Rifa" ) ;
	    case 175: strcat ( model_name, "San Fierro Rifa" ) ;
	    case 176: strcat ( model_name, "Barber" ) ; // магаз скинов
	    case 177: strcat ( model_name, "Barber" ) ; // магаз скинов
	    case 178: strcat ( model_name, "Whore" ) ; // донат
	    case 179: strcat ( model_name, "Ammunation Salesman" ) ;
	    case 180: strcat ( model_name, "Tattoo Artist" ) ; // донат
	    case 181: strcat ( model_name, "Punk" ) ;
	    case 182: strcat ( model_name, "Cab Driver" ) ;
	    case 183: strcat ( model_name, "Normal Ped" ) ;
	    case 184: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 185: strcat ( model_name, "Normal Ped" ) ; // магаз скинов 
	    case 186: strcat ( model_name, "Normal Ped" ) ; // магаз скинов
	    case 187: strcat ( model_name, "Businessman" ) ;
	    case 188: strcat ( model_name, "Normal Ped" ) ;
	    case 189: strcat ( model_name, "Valet" ) ;
	    case 190: strcat ( model_name, "Barbara Schternvart" ) ; // магаз скинов
	    case 191: strcat ( model_name, "Helena Wankstein" ) ;
	    case 192: strcat ( model_name, "Michelle Cannes" ) ; // магаз скинов
	    case 193: strcat ( model_name, "Katie Zhan" ) ; // магаз скинов
	    case 194: strcat ( model_name, "Millie Perkins" ) ;
	    case 195: strcat ( model_name, "Denise Robinson" ) ;
	    case 196: strcat ( model_name, "Farm-Town inhabitant" ) ;
	    case 197: strcat ( model_name, "Hillbilly" ) ;
	    case 198: strcat ( model_name, "Farm-Town inhabitant" ) ; // магаз скинов
	    case 199: strcat ( model_name, "Farm-Town inhabitant" ) ;
	    case 200: strcat ( model_name, "Hillbilly" ) ;
	    case 201: strcat ( model_name, "Farmer" ) ;
	    case 202: strcat ( model_name, "Farmer" ) ;
	    case 203: strcat ( model_name, "Karate Teacher" ) ;
	    case 204: strcat ( model_name, "Karate Teacher" ) ;
	    case 205: strcat ( model_name, "Burger Shot Cashier" ) ;
	    case 206: strcat ( model_name, "Cab Driver" ) ;
	    case 207: strcat ( model_name, "Prostitute" ) ;
	    case 208: strcat ( model_name, "Su Xi Mu" ) ;
	    case 209: strcat ( model_name, "Oriental Noodle stand vendor" ) ;
	    case 210: strcat ( model_name, "Oriental Boating School Instructor" ) ; // магаз скинов
	    case 211: strcat ( model_name, "Clothes shop staff" ) ;
	    case 212: strcat ( model_name, "Homeless" ) ;
	    case 213: strcat ( model_name, "Weird old man" ) ;
	    case 214: strcat ( model_name, "Waitress" ) ;
	    case 215: strcat ( model_name, "Normal Ped" ) ;
	    case 216: strcat ( model_name, "Normal Ped" ) ;
	    case 217: strcat ( model_name, "Clothes shop staff" ) ;
	    case 218: strcat ( model_name, "Normal Ped" ) ;
	    case 219: strcat ( model_name, "Rich Woman" ) ;
	    case 220: strcat ( model_name, "Cab Driver" ) ;
	    case 221: strcat ( model_name, "Normal Ped" ) ;
	    case 222: strcat ( model_name, "Normal Ped" ) ;
	    case 223: strcat ( model_name, "Normal Ped" ) ;
	    case 224: strcat ( model_name, "Normal Ped" ) ;
	    case 225: strcat ( model_name, "Normal Ped" ) ;
	    case 226: strcat ( model_name, "Normal Ped" ) ;
	    case 227: strcat ( model_name, "Oriental Businessman" ) ;
	    case 228: strcat ( model_name, "Oriental Ped" ) ;
	    case 229: strcat ( model_name, "Oriental Ped" ) ;
	    case 230: strcat ( model_name, "Homeless" ) ;
	    case 231: strcat ( model_name, "Normal Ped" ) ;
	    case 232: strcat ( model_name, "Normal Ped" ) ;
	    case 233: strcat ( model_name, "Normal Ped" ) ;
	    case 234: strcat ( model_name, "Cab Driver" ) ;
	    case 235: strcat ( model_name, "Normal Ped" ) ;
	    case 236: strcat ( model_name, "Normal Ped" ) ;
	    case 237: strcat ( model_name, "Prostitute" ) ;
	    case 238: strcat ( model_name, "Prostitute" ) ;
	    case 239: strcat ( model_name, "Homeless" ) ;
	    case 240: strcat ( model_name, "The D.A" ) ;
	    case 241: strcat ( model_name, "Afro-American" ) ;
	    case 242: strcat ( model_name, "Mexican" ) ;
	    case 243: strcat ( model_name, "Prostitute" ) ;
	    case 244: strcat ( model_name, "Stripper" ) ;
	    case 245: strcat ( model_name, "Prostitute" ) ;
	    case 246: strcat ( model_name, "Stripper" ) ;
	    case 247: strcat ( model_name, "Biker" ) ;
	    case 248: strcat ( model_name, "Biker" ) ;
	    case 249: strcat ( model_name, "Pimp" ) ;
	    case 250: strcat ( model_name, "Normal Ped" ) ;
	    case 251: strcat ( model_name, "Lifeguard" ) ;
	    case 252: strcat ( model_name, "Naked Valet" ) ;
	    case 253: strcat ( model_name, "Bus Driver" ) ;
	    case 254: strcat ( model_name, "Biker Drug Dealer" ) ;
	    case 255: strcat ( model_name, "Chauffeur" ) ;
	    case 256: strcat ( model_name, "Stripper" ) ;
	    case 257: strcat ( model_name, "Stripper" ) ;
	    case 258: strcat ( model_name, "Heckler" ) ;
	    case 259: strcat ( model_name, "Heckler" ) ;
	    case 260: strcat ( model_name, "Construction Worker" ) ;
	    case 261: strcat ( model_name, "Cab Driver" ) ;
	    case 262: strcat ( model_name, "Cab Driver" ) ;
	    case 263: strcat ( model_name, "Normal Ped" ) ;
	    case 264: strcat ( model_name, "Clown" ) ;
	    case 265: strcat ( model_name, "Officer Frank Tenpenny" ) ;
	    case 266: strcat ( model_name, "Officer Eddie Pulaski" ) ;
	    case 267: strcat ( model_name, "Officer Jimmy Hernandez" ) ;
	    case 268: strcat ( model_name, "Dwayne" ) ;
	    case 269: strcat ( model_name, "Melvin 'Big Smoke' Harris" ) ;
	    case 270: strcat ( model_name, "Sean 'Sweet' Johnson" ) ;
	    case 271: strcat ( model_name, "Lance 'Ryder' Wilson" ) ;
	    case 272: strcat ( model_name, "Mafia Boss" ) ;
	    case 273: strcat ( model_name, "T-Bone Mendez" ) ;
	    case 274: strcat ( model_name, "Paramedic" ) ;
	    case 275: strcat ( model_name, "Paramedic" ) ;
	    case 276: strcat ( model_name, "Paramedic" ) ;
	    case 277: strcat ( model_name, "Firefighter" ) ;
	    case 278: strcat ( model_name, "Firefighter" ) ;
	    case 279: strcat ( model_name, "Firefighter" ) ;
	    case 280: strcat ( model_name, "Los Santos Police Officer" ) ;
	    case 281: strcat ( model_name, "San Fierro Police Officer" ) ;
	    case 282: strcat ( model_name, "Las Venturas Police Officer" ) ;
	    case 283: strcat ( model_name, "County Sheriff" ) ;
	    case 284: strcat ( model_name, "LSPD Motorbike Cop" ) ;
	    case 285: strcat ( model_name, "S.W.A.T Special Forces" ) ;
	    case 286: strcat ( model_name, "Federal Agent" ) ;
	    case 287: strcat ( model_name, "San Andreas Army" ) ;
	    case 288: strcat ( model_name, "Desert Sheriff" ) ;
	    case 289: strcat ( model_name, "Zero" ) ;
	    case 290: strcat ( model_name, "Ken Rosenberg" ) ;
	    case 291: strcat ( model_name, "Kent Paul" ) ;
	    case 292: strcat ( model_name, "Cesar Vialpando" ) ;
	    case 293: strcat ( model_name, "Jeffery 'OG Loc' Martin" ) ;
	    case 294: strcat ( model_name, "Wu Zi Mu" ) ; // craft
	    case 295: strcat ( model_name, "Michael Toreno" ) ;
	    case 296: strcat ( model_name, "Jizzy B." ) ;
	    case 297: strcat ( model_name, "Madd Dogg" ) ;
	    case 298: strcat ( model_name, "Catalina" ) ;
	    case 299: strcat ( model_name, "Claude Speed" ) ;
	    case 300: strcat ( model_name, "Los Santos Police Officer" ) ; // донат
	    case 301: strcat ( model_name, "San Fierro Police Officer" ) ; // магаз скинов
	    case 302: strcat ( model_name, "Las Venturas Police Officer" ) ; // craft
	    case 303: strcat ( model_name, "Los Santos Police Officer" ) ; // донат
	    case 304: strcat ( model_name, "Los Santos Police Officer" ) ; // craft
	    case 305: strcat ( model_name, "Las Venturas Police Officer" ) ;
	    case 306: strcat ( model_name, "Los Santos Police Officer" ) ;
	    case 307: strcat ( model_name, "San Fierro Police Officer" ) ;
	    case 308: strcat ( model_name, "San Fierro Paramedic" ) ;
	    case 309: strcat ( model_name, "Las Venturas Police Officer" ) ;
	    case 310: strcat ( model_name, "Country Sheriff" ) ; // донат
	    case 311: strcat ( model_name, "Desert Sheriff" ) ; // донат


	    case 312: strcat ( model_name, "Don Carleone" ) ; // case crime
	    case 313: strcat ( model_name, "Джон Уик" ) ; // донат // case crime
	    case 314: strcat ( model_name, "Джокер" ) ; // донат // case crime
	    case 315: strcat ( model_name, "Marshmello" ) ;
	    case 318: strcat ( model_name, "Skin Name" ) ; // донат

	    case 4507: strcat ( model_name, "Skin Name" ) ; // донат
	    case 4508: strcat ( model_name, "Джо Байден" ) ; // event pass
	    case 4509: strcat ( model_name, "Сергей Бодров" ) ; // case crime
	    case 4511: strcat ( model_name, "Ева Элфи (Снег.)" ) ;
	    case 4512: strcat ( model_name, "Неизвестно" ) ; // craft
	    case 4513: strcat ( model_name, "Неизвестно" ) ; // craft
	    case 4516: strcat ( model_name, "S1mple" ) ; // донат
	    case 4517: strcat ( model_name, "Тимати" ) ; // донат

	    case 4521: strcat ( model_name, "Школьник" ) ; // донат
	    case 4522: strcat ( model_name, "Buster" ) ; // донат
	    case 4523: strcat ( model_name, "Elon Musk" ) ; // донат
	    case 4524: strcat ( model_name, "Eva Elfie (nuds)" ) ; // донат
	    case 4525: strcat ( model_name, "Skin Name" ) ; // магаз скинов
	    case 4526: strcat ( model_name, "Skin Name" ) ; // магаз скинов
	    case 4527: strcat ( model_name, "Skin Name" ) ; // магаз скинов
	    case 4528: strcat ( model_name, "Skin Name" ) ; // магаз скинов
	    case 4529: strcat ( model_name, "Хасбик" ) ; // case crime
	    case 4530: strcat ( model_name, "Каха" ) ; // case crime
	    case 4531: strcat ( model_name, "Литвин" ) ; // донат
	    case 4532: strcat ( model_name, "Пчёла" ) ; // case crime
	    case 4533: strcat ( model_name, "Равшан" ) ; // донат
	    case 4534: strcat ( model_name, "Серго" ) ; // case crime
	    case 4535: strcat ( model_name, "Неизвестно" ) ; // craft
	    case 4536: strcat ( model_name, "Неизвестно" ) ; // craft
	    case 4537: strcat ( model_name, "Неизвестно" ) ; // craft
	    case 4538: strcat ( model_name, "Неизвестно" ) ; // craft
	    case 4539: strcat ( model_name, "Неизвестно" ) ; // craft
	    case 4540: strcat ( model_name, "Неизвестно" ) ; // craft
	    case 4541: strcat ( model_name, "Неизвестно" ) ; // craft
	    case 4542: strcat ( model_name, "Неизвестно" ) ; // craft
	    case 4543: strcat ( model_name, "Неизвестно" ) ; // craft
	    case 4544: strcat ( model_name, "Пляжная чика" ) ; // донат
		
	    case 4545: strcat ( model_name, "Big Baby Tape" ) ; // донат
	    case 4546: strcat ( model_name, "Дора" ) ; // донат
	    case 4547: strcat ( model_name, "Кизару" ) ; // донат
	    case 4548: strcat ( model_name, "Клава Кока" ) ; // донат
	    case 4549: strcat ( model_name, "Tenderlybae" ) ; // донат
	    case 4550: strcat ( model_name, "Виктор Цой" ) ; // донат 
	    case 4551: strcat ( model_name, "Normal Ped #10" ) ;
	    case 4552: strcat ( model_name, "Normal Ped #11" ) ;
	    case 4553: strcat ( model_name, "Normal Ped #12" ) ;
	    case 4554: strcat ( model_name, "Normal Ped #13" ) ;
	    case 4555: strcat ( model_name, "Normal Ped #14" ) ; // event pass
	    case 4556: strcat ( model_name, "Муммия" ) ; // донат
		
		case 4557: strcat ( model_name, "Помощница санты" ) ;
		case 4558: strcat ( model_name, "Эльф" ) ;
		case 4559: strcat ( model_name, "Гринч" ) ;
		case 4560: strcat ( model_name, "Шрек" ) ;
		case 4561: strcat ( model_name, "Зимний #1" ) ; // case trucker
		case 4562: strcat ( model_name, "Зимний #2" ) ; // case trucker
		case 4563: strcat ( model_name, "Зимний #3" ) ; // case incass
		case 4564: strcat ( model_name, "Зимний #4" ) ; // case incass
		case 4565: strcat ( model_name, "Зимний #5" ) ;
		case 4566: strcat ( model_name, "Зимний #6" ) ;
		case 4567: strcat ( model_name, "Зимняя #1" ) ;
		case 4568: strcat ( model_name, "Зимняя #2" ) ;
		case 4569: strcat ( model_name, "Зимняя #3" ) ;
		case 4570: strcat ( model_name, "Парень в ушанке СССР" ) ;
		case 4571: strcat ( model_name, "Снеговик" ) ;
		
		case 4572: strcat ( model_name, "Абдурозик" ) ; // case crime
		case 4573: strcat ( model_name, "Галкин" ) ; // event pass
		case 4574: strcat ( model_name, "Гопник" ) ; // крафт
		case 4575: strcat ( model_name, "Мейби Бэйби" ) ; // донат
		case 4576: strcat ( model_name, "Mikki Mouse" ) ; // донат
		case 4577: strcat ( model_name, "Ургант" ) ; // event pass
		case 4578: strcat ( model_name, "Личность #1" ) ; // e2y
		case 4579: strcat ( model_name, "Личность #2" ) ; // e2y
		case 4580: strcat ( model_name, "Горничная" ) ; // valentine
		case 4581: strcat ( model_name, "Личность #3" ) ; // valentine
		case 4582: strcat ( model_name, "Личность #4" ) ; // valentine
		case 4583: strcat ( model_name, "Личность #5" ) ; // valentine
		case 4584: strcat ( model_name, "Личность #6" ) ; // valentine
		
		case 4585: strcat ( model_name, "Woman #1" ) ; // valentine
		case 4586: strcat ( model_name, "Woman #2" ) ; // valentine
		case 4587: strcat ( model_name, "Woman #3" ) ; // valentine
		case 4588: strcat ( model_name, "Woman #4" ) ; // valentine
		case 4589: strcat ( model_name, "Woman #5" ) ; // valentine
		case 4590: strcat ( model_name, "Каннибал" ) ; // донат
		case 4591: strcat ( model_name, "Зомби клоун" ) ; // донат
		case 4592: strcat ( model_name, "Клоун" ) ; // крафт
		case 4593: strcat ( model_name, "Граф Дракула" ) ; // донат
		case 4594: strcat ( model_name, "Из ада" ) ; // крафт
		case 4595: strcat ( model_name, "Самурай" ) ; // клад
		case 4597: strcat ( model_name, "Гейша" ) ; // донат
		case 4598: strcat ( model_name, "Крик" ) ; // case crime
		case 4599: strcat ( model_name, "Выжившая" ) ; // valentine
		case 4600: strcat ( model_name, "Выживший" ) ; // valentine
		case 4601: strcat ( model_name, "Личность #6" ) ; // wheel
		
		case 4603: strcat ( model_name, "Эш" ) ; // craft
		case 4604: strcat ( model_name, "Гейб Ньюэлл" ) ; // craft
		case 4605: strcat ( model_name, "Гена Букин" ) ; // donate
		case 4606: strcat ( model_name, "Вито Корлеоне" ) ; // case crime
		case 4607: strcat ( model_name, "Человек-робот" ) ; // donate
		case 4608: strcat ( model_name, "Стас Барецкий" ) ; // donate
		case 4609: strcat ( model_name, "Дауни Младший" ) ; // donate
		case 4611: strcat ( model_name, "Влад А4" ) ; // donate
		case 4612: strcat ( model_name, "Мелкий" ) ; // donate
		case 4613: strcat ( model_name, "Мелкий 2" ) ; // donate
		case 4614: strcat ( model_name, "Мелкий 3" ) ; // donate
		case 4615: strcat ( model_name, "Игрок #1" ) ; // valentine
		case 4616: strcat ( model_name, "Игрок #2" ) ; // valentine
		case 4617: strcat ( model_name, "Парень со сломанной рукой" ) ; // valentine
		case 4618: strcat ( model_name, "Негр рэпер" ) ; // valentine
		case 4619: strcat ( model_name, "Игрулька #1" ) ; // donate
		case 4620: strcat ( model_name, "Игрулька #2" ) ; // donate
		case 4621: strcat ( model_name, "Игрулька #3" ) ; // donate
		
		case 4622: strcat ( model_name, "Шейх" ) ; // donate
		case 4623: strcat ( model_name, "Байкер #1" ) ; // valentine
		case 4624: strcat ( model_name, "Байкер #2" ) ; // valentine
		case 4625: strcat ( model_name, "Байкер #3" ) ; // valentine
		case 4626: strcat ( model_name, "Байкершка #1" ) ; // valentine
		case 4627: strcat ( model_name, "Новый модный #1" ) ; // e2y
		case 4628: strcat ( model_name, "Новый модный #2" ) ; // e2y
		case 4629: strcat ( model_name, "Новый модный #3" ) ; // e2y
		case 4630: strcat ( model_name, "Спасательный круг" ) ; // donate
		case 4631: strcat ( model_name, "Байкер #4" ) ; // valentine
		case 4632: strcat ( model_name, "Байкер #5" ) ; // valentine
		case 4633: strcat ( model_name, "Байкер #6" ) ; // valentine
		case 4634: strcat ( model_name, "Байкершка #2" ) ; // valentine
		case 4635: strcat ( model_name, "Модник VLone" ) ; // donate
		
		case 4636: strcat ( model_name, "Даня Милохин" ) ; // donate
		case 4637: strcat ( model_name, "Lionel Messi" ) ; // donate
		case 4638: strcat ( model_name, "Mr Pin" ) ; // event pass
		case 4639: strcat ( model_name, "Naruto" ) ; // e2y + event pass
		case 4640: strcat ( model_name, "Детектив" ) ; // newbie pass
		case 4641: strcat ( model_name, "Пляжная девчонка" ) ; // donate
		case 4642: strcat ( model_name, "Валя Карнавал" ) ; // donate
		case 4643: strcat ( model_name, "Анимэшка" ) ; // e2y / valentine
		
		case 4644: strcat ( model_name, "Зеленский" ) ; // donate
		case 4645: strcat ( model_name, "Капитан Америка" ) ; // donate
		case 4646: strcat ( model_name, "Цирилла" ) ; // family
		case 4647: strcat ( model_name, "Дейенерис" ) ; // event pass
		case 4648: strcat ( model_name, "Гендальф" ) ;
		case 4649: strcat ( model_name, "Геральт" ) ; // treasure
		case 4650: strcat ( model_name, "Железный человек" ) ; // donate
		case 4651: strcat ( model_name, "Джеки Чан" ) ; // donate
		case 4652: strcat ( model_name, "Кеноби" ) ; // family
		case 4653: strcat ( model_name, "Джинск" ) ;
		case 4654: strcat ( model_name, "Кратос" ) ;
		case 4655: strcat ( model_name, "Лукашенко" ) ; // donate / event pass
		case 4656: strcat ( model_name, "Мавроди" ) ; // garage / valentine
		case 4657: strcat ( model_name, "Йода" ) ; // donate / event pass
		case 4658: strcat ( model_name, "Бэтмен" ) ; // donate
		case 4659: strcat ( model_name, "Дэвид" ) ; // craft
		case 4660: strcat ( model_name, "Венсдей" ) ; // donate
		case 4661: strcat ( model_name, "Люси" ) ; // craft
		case 4662: strcat ( model_name, "Ребекка" ) ; // craft / valentine
		case 4663: strcat ( model_name, "Харли Квин" ) ; // donate / valentine
		
		case 4664: strcat ( model_name, "Al Pachino" ) ; // donate
		case 4665: strcat ( model_name, "Саша Белый" ) ; // donate
		case 4666: strcat ( model_name, "Getleman #1" ) ; // treasure
		case 4667: strcat ( model_name, "Getleman #2" ) ; // treasure
		case 4668: strcat ( model_name, "Getleman #3" ) ; // event pass
		case 4669: strcat ( model_name, "Getleman #4" ) ; // 
		case 4670: strcat ( model_name, "Getleman #5" ) ; // 
		case 4671: strcat ( model_name, "Getleman #6" ) ; // 
		case 4672: strcat ( model_name, "Main Bomj" ) ; // e2y
		case 4673: strcat ( model_name, "Main #1" ) ; // e2y
		case 4674: strcat ( model_name, "Main #2" ) ; // treasure
		case 4675: strcat ( model_name, "Main #3" ) ; // treasure
		case 4676: strcat ( model_name, "Main #4" ) ; // 
		case 4677: strcat ( model_name, "Main #5" ) ; // 
		case 4678: strcat ( model_name, "Main #6" ) ; // 
		case 4679: strcat ( model_name, "Main #7" ) ; // event pass
		case 4680: strcat ( model_name, "Main #8" ) ; // garage
		case 4681: strcat ( model_name, "Main #9" ) ; // garage
		case 4682: strcat ( model_name, "Монстр" ) ; // 
		case 4683: strcat ( model_name, "Гордон" ) ; // donate
		case 4684: strcat ( model_name, "Zomb1E" ) ; // e2y
		case 4685: strcat ( model_name, "Тыква" ) ; // e2y
		case 4686: strcat ( model_name, "Граф Дракуля" ) ; // e2y
		case 4687: strcat ( model_name, "Волан Де Морт" ) ; // e2y
		case 4688: strcat ( model_name, "Без головы" ) ; //
		case 4689: strcat ( model_name, "Свин" ) ; // e2y
		case 4690: strcat ( model_name, "K1ller" ) ; // e2y
		case 4691: strcat ( model_name, "Charlie Hannem" ) ; // garage
		case 4692: strcat ( model_name, "Купидон" ) ; // donate
		case 4693: strcat ( model_name, "Леголас" ) ; // donate
		
		case 4694: strcat ( model_name, "Заключённый #1" ) ;
		case 4695: strcat ( model_name, "Заключённый #2" ) ;
		case 4696: strcat ( model_name, "Заключённый #3" ) ;
		case 4697: strcat ( model_name, "Заключённый #4" ) ;
		case 4698: strcat ( model_name, "Арагорн" ) ; // treasure
		case 4699: strcat ( model_name, "Bumbl Bee" ) ; // donate
		case 4700: strcat ( model_name, "Jax" ) ; // craft
		case 4701: strcat ( model_name, "Lui Kang" ) ; // craft
		case 4702: strcat ( model_name, "Noob Saimbot" ) ; // craft
		case 4703: strcat ( model_name, "Sonya Blade" ) ; // craft
		case 4704: strcat ( model_name, "Shan Zhi" ) ; // craft
		case 4705: strcat ( model_name, "Raiden" ) ; // donate
		case 4706: strcat ( model_name, "Scorpion" ) ; // donate
		case 4707: strcat ( model_name, "Sub Zero" ) ; // donate
		case 4708: strcat ( model_name, "Леший" ) ;
		case 4709: strcat ( model_name, "Optimus Prime" ) ; // donate
		case 4710: strcat ( model_name, "Scoobie Doo" ) ; // donate
		case 4711: strcat ( model_name, "Shaggie" ) ; // event pass
		case 4712: strcat ( model_name, "Джон Сноу" ) ;
		case 4713: strcat ( model_name, "Трис" ) ;
		case 4714: strcat ( model_name, "Dart Vader" ) ; // donate
		case 4715: strcat ( model_name, "Velma" ) ; // treasure
		case 4716: strcat ( model_name, "Йен" ) ; // event pass
		
		case 4717: strcat ( model_name, "Паша Техник" ) ; // treasure
		case 4718: strcat ( model_name, "PUBG #1 (женск.)" ) ; // winter quest
		case 4719: strcat ( model_name, "PUBG #1" ) ; // winter quest
		case 4720: strcat ( model_name, "PUBG #2 (женск.)" ) ; // donate case
		case 4721: strcat ( model_name, "PUBG #2" ) ; // donate case
		case 4722: strcat ( model_name, "PUBG #3 (женск.)" ) ; // event pass
		case 4723: strcat ( model_name, "PUBG #3" ) ; // event pass
		case 4724: strcat ( model_name, "PUBG #4 (женск.)" ) ; // event pass
		case 4725: strcat ( model_name, "PUBG #4" ) ; // event pass
		case 4726: strcat ( model_name, "PUBG #5 (женск.)" ) ; // event pass
		case 4727: strcat ( model_name, "PUBG #5" ) ;
		case 4728: strcat ( model_name, "Диана Шурыгина" ) ; // event pass
		case 4729: strcat ( model_name, "Spider Man" ) ; // donate case
		case 4730: strcat ( model_name, "Левая" ) ; // garage
		case 4731: strcat ( model_name, "Правая" ) ; // garage
		case 4732: strcat ( model_name, "Venom" ) ; // craft
		
		case 4733: strcat ( model_name, "Бэт" ) ;
		case 4734: strcat ( model_name, "Морти" ) ; // donate
		case 4735: strcat ( model_name, "Осёл" ) ; // event pass
		case 4736: strcat ( model_name, "Рик" ) ; // donate
		case 4737: strcat ( model_name, "Фиона #1" ) ;
		case 4738: strcat ( model_name, "Фиона #2" ) ;
		case 4739: strcat ( model_name, "Шрек #1" ) ;
		case 4740: strcat ( model_name, "Шрек #2" ) ;
		case 4741: strcat ( model_name, "Вова Адидас" ) ; // donate
		case 4742: strcat ( model_name, "Лорд Фаркуад" ) ;
		case 4743: strcat ( model_name, "Маратик" ) ; // donate
		case 4744: strcat ( model_name, "Пальто" ) ; // donate
		case 4745: strcat ( model_name, "Птичья личность" ) ; // family
		case 4746: strcat ( model_name, "Саммер" ) ; // family
	    default: strcat ( model_name, "Unknown" ) ;
	}
	return model_name ;
}