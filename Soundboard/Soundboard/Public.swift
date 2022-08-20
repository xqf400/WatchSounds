//
//  Public.swift
//  Soundboard
//
//  Created by Fabian Kuschke on 08.12.21.
//

import Foundation
import AVFoundation
import MediaPlayer
import JGProgressHUD

var player: AVAudioPlayer?
let soundVolume:Float = 0.7
var allsSoundArray: [SoundModel] = []
var mseSoundArray: [SoundModel] = []
var nluSoundArray: [SoundModel] = []
var ploSoundArray: [SoundModel] = []
var esoSoundArray: [SoundModel] = []
var fkuSoundArray:[SoundModel] = []

var favSoundsArray:[SoundModel] = []
var nluImageNames :[String] = ["nils.png","nils2.png","nils3.png","nils4.png","nils5.png","nils6.png","nils7.png"]
var cachesURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
var messagesAreAllowed = false
var playAMessage = false
var playSoundString = ""
var loundSound = true

let denken = SoundModel(soundId: 0, soundName: "Denken", soundImage: "denken.png", soundFile: "denken", soundVolume: soundVolume)
let Spass__kurz = SoundModel(soundId: 1, soundName: "Spass kurz", soundImage: "spass.png", soundFile: "Spass__kurz", soundVolume: soundVolume)
let Spass__mittel = SoundModel(soundId: 2, soundName: "Spass mittel", soundImage: "spass.png", soundFile: "Spass__mittel", soundVolume: soundVolume)
let Spass_lang_lang = SoundModel(soundId: 3, soundName: "Spass lang", soundImage: "spass.png", soundFile: "Spass_lang_lang", soundVolume: soundVolume)
let Tag__kurz = SoundModel(soundId: 4, soundName: "Tag kurz", soundImage: "schoenertag.png", soundFile: "Tag__kurz", soundVolume: soundVolume)
let Tag__mittel = SoundModel(soundId: 5, soundName: "Tag mittel", soundImage: "schoenertag.png", soundFile: "Tag__mittel", soundVolume: soundVolume)
let Tag_lang = SoundModel(soundId: 6, soundName: "Tag lang", soundImage: "schoenertag.png", soundFile: "Tag_lang", soundVolume: soundVolume)
let alterFalter = SoundModel(soundId: 7, soundName: "Alter Falter", soundImage: "geil.png", soundFile: "alterFalter", soundVolume: soundVolume)
let delfin = SoundModel(soundId: 8, soundName: "Delfin", soundImage: "delfin.png", soundFile: "Delfin", soundVolume: soundVolume)
let excited_kurz = SoundModel(soundId: 9, soundName: "Excited kurz", soundImage: "excited.png", soundFile: "excited_kurz", soundVolume: soundVolume)
let excited_lang = SoundModel(soundId: 10, soundName: "Excited lang", soundImage: "excited.png", soundFile: "excited_lang", soundVolume: soundVolume)
let mimimi = SoundModel(soundId: 11, soundName: "Mimimi", soundImage: "mimimi.png", soundFile: "mimimi", soundVolume: soundVolume)
let SchoenistesaufderWeltzusein = SoundModel(soundId: 12, soundName: "Schoen ist es auf der Welt zu sein", soundImage: "schoenwelt.png", soundFile: "SchoenistesaufderWeltzusein", soundVolume: soundVolume)
let SchoenerTagStuttgarter = SoundModel(soundId: 13, soundName: "Schoener Tag Stuttgarter", soundImage: "schoenertagstuttgarter.png", soundFile: "SchoenerTagStuttgarter", soundVolume: soundVolume)
let ichLiebeDich = SoundModel(soundId: 14, soundName: "ich Liebe Dich", soundImage: "ichliebedich.png", soundFile: "ichLiebeDich", soundVolume: soundVolume)
let tellmewhylang = SoundModel(soundId: 15, soundName: "tell me why lang", soundImage: "tellmewhy.png", soundFile: "tellmewhylang", soundVolume: soundVolume)
let tellmewhykurz = SoundModel(soundId: 16, soundName: "tell me why kurz", soundImage: "tellmewhy.png", soundFile: "tellmewhykurz", soundVolume: soundVolume)
let gehdochzuhause = SoundModel(soundId: 17, soundName: "geh doch zu hause", soundImage: "gehdochheim.png", soundFile: "gehdochzuhause", soundVolume: soundVolume)
let danngehdochzunetto = SoundModel(soundId: 18, soundName: "Dann geh doch zu Netto", soundImage: "gehdochnetto.png", soundFile: "danngehdochzunetto", soundVolume: soundVolume)
let imperialmarch = SoundModel(soundId: 19, soundName: "Imperial March", soundImage: "imperialmarch.png", soundFile: "imperialmarch", soundVolume: soundVolume)

let JedeZelleKurz = SoundModel(soundId: 20, soundName: "Jede Zelle Kurz", soundImage: "jedezelle.png", soundFile: "JedeZelleKurz", soundVolume: soundVolume)
let JedeZelleLang = SoundModel(soundId: 21, soundName: "Jede Zelle Lang", soundImage: "jedezelle.png", soundFile: "JedeZelleLang", soundVolume: soundVolume)
let erlebtnochkurz = SoundModel(soundId: 22, soundName: "er lebt noch kurz", soundImage: "jaerlebtnoch.png", soundFile: "erlebtnochkurz", soundVolume: soundVolume)
let erlebtnochlang = SoundModel(soundId: 23, soundName: "er lebt noch lang", soundImage: "jaerlebtnoch.png", soundFile: "erlebtnochlang", soundVolume: soundVolume)
let jajalang = SoundModel(soundId: 24, soundName: "Was heisst hier jaja lang", soundImage: "jaja.png", soundFile: "jajalang", soundVolume: soundVolume)
let jajakurz = SoundModel(soundId: 25, soundName: "Was heisst hier jaja", soundImage: "jaja.png", soundFile: "jajakurz", soundVolume: soundVolume)
let miracolikurz = SoundModel(soundId: 26, soundName: "Miracoli kurz", soundImage: "miracoli.png", soundFile: "miracolikurz", soundVolume: soundVolume)
let miracolilang = SoundModel(soundId: 27, soundName: "Miracoli lang", soundImage: "miracoli.png", soundFile: "miracolilang", soundVolume: soundVolume)
let OneMoreTime = SoundModel(soundId: 28, soundName: "One More Time", soundImage: "Onemoretime.png", soundFile: "OneMoreTime", soundVolume: soundVolume)
let HitMeBabyOneMoreTime = SoundModel(soundId: 29, soundName: "Hit Me Baby One More Time", soundImage: "HitMeBabyOneMoreTime.png", soundFile: "HitMeBabyOneMoreTime", soundVolume: soundVolume)
let letsgo = SoundModel(soundId: 30, soundName: "lets go", soundImage: "letsgo.png", soundFile: "letsgo", soundVolume: soundVolume)
let esel = SoundModel(soundId: 31, soundName: "esel", soundImage: "esel.png", soundFile: "esel", soundVolume: soundVolume)
let everbodydancenowlang = SoundModel(soundId: 32, soundName: "everbody dance now lang", soundImage: "everbodydancenow.png", soundFile: "everbodydancenowlang", soundVolume: soundVolume)
let everbodydancenowmittel = SoundModel(soundId: 33, soundName: "everbody dance now mittel", soundImage: "everbodydancenow.png", soundFile: "everbodydancenowmittel", soundVolume: soundVolume)
let everbodydancenowkurz = SoundModel(soundId: 34, soundName: "everbody dance now kurz", soundImage: "everbodydancenow.png", soundFile: "everbodydancenowkurz", soundVolume: soundVolume)
let IloveitIDontcare = SoundModel(soundId: 35, soundName: "I love it I Dont care", soundImage: "IloveitIDontcare.png", soundFile: "IloveitIDontcare", soundVolume: soundVolume)
let IDontcare = SoundModel(soundId: 36, soundName: "I Dont care", soundImage: "IDontcare.png", soundFile: "IDontcare", soundVolume: soundVolume)
let Iloveit = SoundModel(soundId: 37, soundName: "I love it", soundImage: "Iloveit.png", soundFile: "Iloveit", soundVolume: soundVolume)
let Mallezuruck = SoundModel(soundId: 10, soundName: "Malle zurück", soundImage: "Mallezuruck.png", soundFile: "Mallezuruck", soundVolume: soundVolume)
let vielleichtsekt = SoundModel(soundId: 38, soundName: "vielleicht sekt", soundImage: "vielleichtsekt.png", soundFile: "vielleichtsekt", soundVolume: soundVolume)
let BaDumTss = SoundModel(soundId: 39, soundName: "Ba Dum Tss", soundImage: "BaDumTss.png", soundFile: "BaDumTss", soundVolume: soundVolume)
let wasmachensachen = SoundModel(soundId: 40, soundName: "was machen sachen", soundImage: "wasmachensachen.png", soundFile: "wasmachensachen", soundVolume: soundVolume)
let ComputerSagtNein = SoundModel(soundId: 41, soundName: "Computer Sagt Nein", soundImage: "ComputerSagtNein.png", soundFile: "ComputerSagtNein", soundVolume: 1.0)

let lollipop_kurz = SoundModel(soundId: 42, soundName: "Lollipop kurz", soundImage: "lollipop.png", soundFile: "lollipop_kurz", soundVolume: 1.0)
let lollipop_long = SoundModel(soundId: 43, soundName: "Lollipop long", soundImage: "lollipop.png", soundFile: "Lollipop_long", soundVolume: 1.0)
let lollipop1 = SoundModel(soundId: 44, soundName: "Lollipop 1", soundImage: "lollipop.png", soundFile: "Lollipop1", soundVolume: 1.0)
let lollipop2 = SoundModel(soundId: 45, soundName: "Lollipop 2", soundImage: "lollipop.png", soundFile: "Lollipop2", soundVolume: 1.0)
let lollipop_pop = SoundModel(soundId: 46, soundName: "Lollipop pop", soundImage: "lollipop.png", soundFile: "Lollipop_pop", soundVolume: 1.0)

let EsTutMirLeid = SoundModel(soundId: 47, soundName: "Es Tut Mir Leid", soundImage: "EsTutMirLeid.png", soundFile: "EsTutMirLeid", soundVolume: soundVolume)
let EsTutMirLeidPocahontas = SoundModel(soundId: 48, soundName: "Es Tut Mir Leid Pocahontas", soundImage: "EsTutMirLeid.png", soundFile: "EsTutMirLeidPocahontas", soundVolume: soundVolume)
let IfYoureHappy = SoundModel(soundId: 49, soundName: "If Youre Happy", soundImage: "IfYoureHappy.png", soundFile: "IfYoureHappyShort", soundVolume: soundVolume)
let IfYoureHappyClap = SoundModel(soundId: 50, soundName: "If Youre Happy clap", soundImage: "IfYoureHappy.png", soundFile: "IfYoureHappy", soundVolume: 1.0)
let VerstehIchNichtKurz = SoundModel(soundId: 51, soundName: "Versteh Ich Nicht Kurz", soundImage: "VerstehIchNicht.png", soundFile: "VerstehIchNichtKurz", soundVolume: 1.0)
let VerstehIchNichtLang = SoundModel(soundId: 52, soundName: "Versteh Ich Nicht Lang", soundImage: "VerstehIchNicht.png", soundFile: "VerstehIchNichtLang", soundVolume: 1.0)
let CantinaBand = SoundModel(soundId: 53, soundName: "Cantina Band", soundImage: "CantinaBand.png", soundFile: "CantinaBand", soundVolume: soundVolume)
let QuatschMerkschSelber = SoundModel(soundId: 54, soundName: "Merksch selber", soundImage: "QuatschMerkschSelber.png", soundFile: "QuatschMerkschSelber", soundVolume: soundVolume)
let Layla = SoundModel(soundId: 55, soundName: "Layla kurz", soundImage: "Layla.png", soundFile: "LaylaKurz", soundVolume: soundVolume)
let imperialmarchLong = SoundModel(soundId: 56, soundName: "Imperial March Long", soundImage: "ImperialMarchLong.png", soundFile: "ImperialMarchLong", soundVolume: soundVolume)

//MARK: Fabi Sounds
let leidernochnicht = SoundModel(soundId: 100, soundName: "leider noch nicht", soundImage: "fabi.png", soundFile: "leidernochnicht", soundVolume: 1)
let GenauFabi = SoundModel(soundId: 101, soundName: "genau", soundImage: "fabi.png", soundFile: "GenauFabi", soundVolume: 1)
let JagernedochFabi = SoundModel(soundId: 102, soundName: "Ja gerne doch", soundImage: "fabi.png", soundFile: "JagernedochFabi", soundVolume: 1)
let MaschineFabi = SoundModel(soundId: 103, soundName: "maschine", soundImage: "fabi.png", soundFile: "MaschineFabi", soundVolume: 1)
let NichtperfektaberesreichtFabi = SoundModel(soundId: 104, soundName: "Nicht perfekt aber es reicht", soundImage: "fabi.png", soundFile: "NichtperfektaberesreichtFabi", soundVolume: 1)
let SovieldazuFabi = SoundModel(soundId: 105, soundName: "so viel dazu", soundImage: "fabi.png", soundFile: "SovieldazuFabi", soundVolume: 1)
let unddasmacheichjetzteinfachmalFabi = SoundModel(soundId: 106, soundName: "und das mache ich jetzt einfach mal", soundImage: "fabi.png", soundFile: "unddasmacheichjetzteinfachmalFabi", soundVolume: 1)
let Konsultant = SoundModel(soundId: 106, soundName: "konsultant", soundImage: "fabi.png", soundFile: "fku_Konsultant", soundVolume: 1)

//Con Sounds

//MARK: Pascal
let hallohieristPascal = SoundModel(soundId: 140, soundName: "hallo hier ist Pascal", soundImage: "pascal.png", soundFile: "hallohieristPascal", soundVolume: 1)
let halloPascalkurz = SoundModel(soundId: 141, soundName: "hallo kurz", soundImage: "pascal.png", soundFile: "halloPascalkurz", soundVolume: 1)
let halloPascalvonkuk = SoundModel(soundId: 142, soundName: "hallo von kuk", soundImage: "pascal.png", soundFile: "halloPascalvonkuk", soundVolume: 1)
let PLO_aehm = SoundModel(soundId: 143, soundName: "aehm", soundImage: "pascal.png", soundFile: "PLO_aehm", soundVolume: 1)

//MARK: Nils 32
//let gutDasWirdasAufnehmen = SoundModel(soundId: 150, soundName: "gut Das Wir das Aufnehmen", soundImage: "nils.png", soundFile: "gutDasWirdasAufnehmen", soundVolume: 1)
let nlu_jaja = SoundModel(soundId: 151, soundName: "jaja", soundImage: "nils.png", soundFile: "nlu_jaja", soundVolume: 1)
let nlu_ja = SoundModel(soundId: 152, soundName: "ja", soundImage: "nils.png", soundFile: "nlu_ja", soundVolume: 1)
let nlu_ja_des_versteh_ich = SoundModel(soundId: 153, soundName: "ja des versteh ich", soundImage: "nils.png", soundFile: "nlu_ja_des_versteh_ich", soundVolume: 1)
let nlu_haha = SoundModel(soundId: 154, soundName: "haha", soundImage: "nils.png", soundFile: "nlu_haha", soundVolume: 1)
let nlu_gut = SoundModel(soundId: 155, soundName: "gut", soundImage: "nils.png", soundFile: "nlu_gut", soundVolume: 1)
let nlu_genau2 = SoundModel(soundId: 156, soundName: "genau2", soundImage: "nils.png", soundFile: "nlu_genau2", soundVolume: 1)
let nlu_genau = SoundModel(soundId: 157, soundName: "genau", soundImage: "nils.png", soundFile: "nlu_genau", soundVolume: 1)
let nlu_direkt_loslegen = SoundModel(soundId: 158, soundName: "direkt loslegen", soundImage: "nils.png", soundFile: "nlu_direkt_loslegen", soundVolume: 1)
let nlu_des_Bekommen_wir_hin = SoundModel(soundId: 159, soundName: "des Bekommen wir hin", soundImage: "nils.png", soundFile: "nlu_des_Bekommen_wir_hin", soundVolume: 1)
let nlu_am_montag_passiert = SoundModel(soundId: 160, soundName: "am montag passiert", soundImage: "nils.png", soundFile: "nlu_am_montag_passiert", soundVolume: 1)
let nlu_alles_nicht_so_dramatisch = SoundModel(soundId: 161, soundName: "alles nicht so dramatisch", soundImage: "nils.png", soundFile: "nlu_alles_nicht_so_dramatisch", soundVolume: 1)
let nlu_ah_okay = SoundModel(soundId: 162, soundName: "ah okay", soundImage: "nils.png", soundFile: "nlu_ah_okay", soundVolume: 1)
let nlu_jap_dann_ist_es_halt_so = SoundModel(soundId: 163, soundName: "jap dann ist es halt so", soundImage: "nils.png", soundFile: "nlu_jap_dann_ist_es_halt_so", soundVolume: 1)
let nlu_tututu = SoundModel(soundId: 164, soundName: "tututu", soundImage: "nils.png", soundFile: "nlu_tututu", soundVolume: 1)
let nlu_nicht_vorher_hin = SoundModel(soundId: 165, soundName: "nicht vorherhin", soundImage: "nils.png", soundFile: "nlu_nicht_vorher_hin", soundVolume: 1)

let nlu_allein_hinbekommen_wuerdet = SoundModel(soundId: 166, soundName: "allein hinbekommen wuerdet", soundImage: "nils.png", soundFile: "nlu_allein_hinbekommen_wuerdet", soundVolume: 1)
let nlu_bekommen_wir_nicht_vorher_hin = SoundModel(soundId: 167, soundName: "bekommen wir nicht vorher hin", soundImage: "nils.png", soundFile: "nlu_bekommen_wir_nicht_vorher_hin", soundVolume: 1)
let nlu_danke = SoundModel(soundId: 168, soundName: "danke", soundImage: "nils.png", soundFile: "nlu_danke", soundVolume: 1)
let nlu_gut_das_wir_das_aufnehmen = SoundModel(soundId: 169, soundName: "gut das wir das aufnehmen", soundImage: "nils.png", soundFile: "nlu_gut_das_wir_das_aufnehmen", soundVolume: 1)
let nlu_gut2 = SoundModel(soundId: 170, soundName: "gut2", soundImage: "nils.png", soundFile: "nlu_gut2", soundVolume: 1)
let nlu_guut = SoundModel(soundId: 171, soundName: "guut", soundImage: "nils.png", soundFile: "nlu_guut", soundVolume: 1)
let nlu_haben_sie_sonst_no_was = SoundModel(soundId: 172, soundName: "haben sie sonst no was", soundImage: "nils.png", soundFile: "nlu_haben_sie_sonst_no_was", soundVolume: 1)
let nlu_herr_seipel = SoundModel(soundId: 173, soundName: "herr seipel", soundImage: "nils.png", soundFile: "nlu_herr_seipel", soundVolume: 1)
let nlu_is_halt_so = SoundModel(soundId: 174, soundName: "is halt so", soundImage: "nils.png", soundFile: "nlu_is_halt_so", soundVolume: 1)
let nlu_jap = SoundModel(soundId: 175, soundName: "jap", soundImage: "nils.png", soundFile: "nlu_jap", soundVolume: 1)
let nlu_mathias = SoundModel(soundId: 176, soundName: "mathias", soundImage: "nils.png", soundFile: "nlu_mathias", soundVolume: 1)
let nlu_montag_gemeinsam = SoundModel(soundId: 177, soundName: "montag gemeinsam", soundImage: "nils.png", soundFile: "nlu_montag_gemeinsam", soundVolume: 1)
let nlu_muess_mer_damit_leben = SoundModel(soundId: 178, soundName: "muess mer damit leben", soundImage: "nils.png", soundFile: "nlu_muess_mer_damit_leben", soundVolume: 1)
let nlu_muess_mer_mit_umgehen = SoundModel(soundId: 179, soundName: "muess mer mit umgehen", soundImage: "nils.png", soundFile: "nlu_muess_mer_mit_umgehen", soundVolume: 1)
let nlu_okay2 = SoundModel(soundId: 180, soundName: "okay2", soundImage: "nils.png", soundFile: "nlu_okay2", soundVolume: 1)
let nlu_ordentlich_dokumentiert = SoundModel(soundId: 181, soundName: "ordentlich dokumentiert", soundImage: "nils.png", soundFile: "nlu_ordentlich_dokumentiert", soundVolume: 1)
let nlu_perfekt = SoundModel(soundId: 182, soundName: "perfekt", soundImage: "nils.png", soundFile: "nlu_perfekt", soundVolume: 1)
let nlu_meeting = SoundModel(soundId: 183, soundName: "meeting", soundImage: "nils.png", soundFile: "nlumeeting", soundVolume: 1)

//MARK: Matze 32
//let dannMachmerdesSoToilette = SoundModel(soundId: 260, soundName: "dann Mach mer des So Toilette", soundImage: "matze.png", soundFile: "dannMachmerdesSoToilette", soundVolume: 1)
//let toiletteLang = SoundModel(soundId: 261, soundName: "toilette Lang", soundImage: "matze.png", soundFile: "toiletteLang", soundVolume: 1)
//let dannMachmerdesDochSo = SoundModel(soundId: 262, soundName: "dann Mach mer des Doch So", soundImage: "matze.png", soundFile: "dannMachmerdesDochSo", soundVolume: 1)
//let matzeToilette = SoundModel(soundId: 263, soundName: "matze Toilette", soundImage: "matze.png", soundFile: "matzeToilette", soundVolume: 1)
let halloMatze = SoundModel(soundId: 264, soundName: "hallo Matze", soundImage: "matze.png", soundFile: "halloMatze", soundVolume: 1)
let halloWillkommenMatze = SoundModel(soundId: 265, soundName: "hallo Willkommen Matze", soundImage: "matze.png", soundFile: "halloWillkommenMatze", soundVolume: 1)
let DaswillwohldurchdachtseinMatze = SoundModel(soundId: 266, soundName: "das will wohl durchdacht sein", soundImage: "matze1.gif", soundFile: "DaswillwohldurchdachtseinMatze", soundVolume: 1)
let fabiankuschkeMatze = SoundModel(soundId: 267, soundName: "fabian Kuschke", soundImage: "matze.png", soundFile: "fabiankuschkeMatze", soundVolume: 1)
let meinNameistMathiasSeipel = SoundModel(soundId: 268, soundName: "mein Name ist Mathias Seipel", soundImage: "matze.png", soundFile: "meinNameistMathiasSeipel", soundVolume: 1)
let smartMatze = SoundModel(soundId: 269, soundName: "smart", soundImage: "matze.png", soundFile: "smartMatze", soundVolume: 1)
let unserslogan = SoundModel(soundId: 270, soundName: "unser Slogan", soundImage: "matze.png", soundFile: "unserslogan", soundVolume: 1)
let mse_zum_naechsten_punkt = SoundModel(soundId: 271, soundName: "zum naechsten punkt", soundImage: "matze.png", soundFile: "mse_zum_naechsten_punkt", soundVolume: 1)
let mse_so_aehm = SoundModel(soundId: 272, soundName: "so aehm", soundImage: "matze1.gif", soundFile: "mse_so_aehm", soundVolume: 1)
let mse_richtig = SoundModel(soundId: 273, soundName: "richtig", soundImage: "matze.png", soundFile: "mse_richtig", soundVolume: 1)
let mse_nur_bedingt_gemacht = SoundModel(soundId: 274, soundName: "nur bedingt gemacht", soundImage: "matze.png", soundFile: "mse_nur_bedingt_gemacht", soundVolume: 1)
let mse_nochmal_angucken = SoundModel(soundId: 275, soundName: "nochmal angucken", soundImage: "matze.png", soundFile: "mse_nochmal_angucken", soundVolume: 1)
let mse_jaah = SoundModel(soundId: 276, soundName: "jaah", soundImage: "matze1.gif", soundFile: "mse_jaah", soundVolume: 1)
let mse_ich_weiss_jetzt_nicht_wer = SoundModel(soundId: 277, soundName: "ich weiss jetzt nicht wer", soundImage: "matze.png", soundFile: "mse_ich_weiss_jetzt_nicht_wer", soundVolume: 1)
let mse_guuuut = SoundModel(soundId: 278, soundName: "guuuut", soundImage: "matze.png", soundFile: "mse_guuuut", soundVolume: 1)
let mse_gut_wunderbar = SoundModel(soundId: 279, soundName: "gut wunderbar", soundImage: "matze1.gif", soundFile: "mse_gut_wunderbar", soundVolume: 1)
let mse_gut_das_war_ja_das_hier = SoundModel(soundId: 280, soundName: "gut das war jadas hier", soundImage: "matze.png", soundFile: "mse_gut_das_war_ja_das_hier", soundVolume: 1)
let mse_des_seh_ich_jetzt_unproblematisch = SoundModel(soundId: 281, soundName: "des seh ich jetzt unproblematisch", soundImage: "matze.png", soundFile: "mse_des_seh_ich_jetzt_unproblematisch", soundVolume: 1)
let mse_des_passt = SoundModel(soundId: 282, soundName: "des passt", soundImage: "matze1.gif", soundFile: "mse_des_passt", soundVolume: 1)
let mse_des_muess_mer_gucken = SoundModel(soundId: 283, soundName: "des muess mer gucken", soundImage: "matze.png", soundFile: "mse_des_muess_mer_gucken", soundVolume: 1)
let mse_aehm = SoundModel(soundId: 284, soundName: "ehm", soundImage: "matze.png", soundFile: "mse_aehm", soundVolume: 1)

let MSE_Und_ich_sag_aber_ok = SoundModel(soundId: 285, soundName: "und ich sag aber ok", soundImage: "matze.png", soundFile: "MSE_Und_ich_sag_aber_ok", soundVolume: 1)
let MSE_Die_Katze_im_Sack = SoundModel(soundId: 286, soundName: "die Katze im Sack", soundImage: "matze1.gif", soundFile: "MSE_Die_Katze_im_Sack", soundVolume: 1)
let MSE_Mein_Name_is_ehm = SoundModel(soundId: 287, soundName: "mein Name is ehm", soundImage: "matze1.gif", soundFile: "MSE_Mein_Name_is_ehm", soundVolume: 1)

let mse_danke_nlu_schoenes_we = SoundModel(soundId: 288, soundName: "danke nlu schoenes we", soundImage: "matze.png", soundFile: "mse_danke_nlu_schoenes_we", soundVolume: 1)
let mse_dankeschoen_mit_nlu = SoundModel(soundId: 289, soundName: "dankeschoen mit nlu", soundImage: "matze.png", soundFile: "mse_dankeschoen_mit_nlu", soundVolume: 1)
let mse_dann_mach_mer_des_doch_so = SoundModel(soundId: 290, soundName: "dann mach mer des doch so", soundImage: "matze1.gif", soundFile: "mse_dann_mach_mer_des_doch_so", soundVolume: 1)
let mse_ich_muss_aufs_klo_und_aufnehmen = SoundModel(soundId: 291, soundName: "ich muss aufs klo und aufnehmen", soundImage: "matze.png", soundFile: "mse_ich_muss_aufs_klo_und_aufnehmen", soundVolume: 1)
let mse_ich_muss_aufs_klo = SoundModel(soundId: 292, soundName: "ich muss aufs klo", soundImage: "matze.png", soundFile: "mse_ich_muss_aufs_klo", soundVolume: 1)
let mse_mathias_seipel = SoundModel(soundId: 293, soundName: "mathias seipel", soundImage: "matze.png", soundFile: "mse_mathias_seipel", soundVolume: 1)
let mse_tschuess = SoundModel(soundId: 294, soundName: "tschuess", soundImage: "matze1.gif", soundFile: "mse_tschuess", soundVolume: 1)
let mse_wunderbar = SoundModel(soundId: 295, soundName: "wunderbar", soundImage: "matze.png", soundFile: "mse_wunderbar", soundVolume: 1)

let mse_3 = SoundModel(soundId: 296, soundName: "3", soundImage: "3jorge.gif", soundFile: "mse3", soundVolume: 1)
let mse_NochFragen = SoundModel(soundId: 297, soundName: "Noch Fragen?", soundImage: "matze.png", soundFile: "mseNochFragen", soundVolume: 1)


//MARK: Enrico
let echtJetzt = SoundModel(soundId: 590, soundName: "echt Jetzt", soundImage: "enrico.png", soundFile: "echtJetzt", soundVolume: 1)
let findeEineLoesung = SoundModel(soundId: 591, soundName: "finde eine Loesung", soundImage: "enrico.png", soundFile: "findeEineLoesung", soundVolume: 1)
let okay = SoundModel(soundId: 592, soundName: "okay", soundImage: "enrico.png", soundFile: "okay", soundVolume: 1)



public func addAllSound(){
    //allsSoundArray.append(dannMachmerdesSoToilette)
    //allsSoundArray.append(dannMachmerdesDochSo)
    //allsSoundArray.append(toiletteLang)
    //allsSoundArray.append(matzeToilette)
    //allsSoundArray.append(gutDasWirdasAufnehmen)

    allsSoundArray.append(hallohieristPascal)
    allsSoundArray.append(halloPascalkurz)
    allsSoundArray.append(halloPascalvonkuk)
    allsSoundArray.append(PLO_aehm)

    allsSoundArray.append(Tag__kurz)
    allsSoundArray.append(delfin)
    allsSoundArray.append(excited_kurz)
    allsSoundArray.append(excited_lang)
    allsSoundArray.append(mimimi)
    allsSoundArray.append(SchoenistesaufderWeltzusein)
    allsSoundArray.append(SchoenerTagStuttgarter)
    allsSoundArray.append(tellmewhylang)
    allsSoundArray.append(tellmewhykurz)
    allsSoundArray.append(gehdochzuhause)
    allsSoundArray.append(Spass_lang_lang)
    allsSoundArray.append(Tag__mittel)
    allsSoundArray.append(Tag_lang)
    allsSoundArray.append(alterFalter)
    allsSoundArray.append(ichLiebeDich)
    allsSoundArray.append(danngehdochzunetto)
    allsSoundArray.append(imperialmarch)
    allsSoundArray.append(imperialmarchLong)
    allsSoundArray.append(denken)
    allsSoundArray.append(Spass__kurz)
    allsSoundArray.append(Spass__mittel)
    allsSoundArray.append(JedeZelleKurz)
    allsSoundArray.append(JedeZelleLang)
    allsSoundArray.append(erlebtnochkurz)
    allsSoundArray.append(erlebtnochlang)
    allsSoundArray.append(jajalang)
    allsSoundArray.append(jajakurz)
    allsSoundArray.append(miracolikurz)
    allsSoundArray.append(miracolilang)
    allsSoundArray.append(OneMoreTime)
    allsSoundArray.append(HitMeBabyOneMoreTime)
    allsSoundArray.append(letsgo)
    allsSoundArray.append(esel)
    allsSoundArray.append(everbodydancenowlang)
    allsSoundArray.append(ComputerSagtNein)
    allsSoundArray.append(wasmachensachen)
    allsSoundArray.append(BaDumTss)
    allsSoundArray.append(Mallezuruck)
    allsSoundArray.append(vielleichtsekt)
    allsSoundArray.append(Iloveit)
    allsSoundArray.append(IDontcare)
    allsSoundArray.append(IloveitIDontcare)
    allsSoundArray.append(everbodydancenowkurz)
    allsSoundArray.append(everbodydancenowmittel)
    
    
    allsSoundArray.append(mse_danke_nlu_schoenes_we)
    allsSoundArray.append(mse_dankeschoen_mit_nlu)
    allsSoundArray.append(mse_dann_mach_mer_des_doch_so)
    allsSoundArray.append(mse_ich_muss_aufs_klo)
    allsSoundArray.append(mse_ich_muss_aufs_klo_und_aufnehmen)
    allsSoundArray.append(mse_mathias_seipel)
    allsSoundArray.append(mse_tschuess)
    allsSoundArray.append(mse_wunderbar)
    allsSoundArray.append(mse_zum_naechsten_punkt)
    allsSoundArray.append(mse_so_aehm)
    allsSoundArray.append(mse_richtig)
    allsSoundArray.append(mse_nur_bedingt_gemacht)
    allsSoundArray.append(mse_nochmal_angucken)
    allsSoundArray.append(mse_jaah)
    allsSoundArray.append(mse_ich_weiss_jetzt_nicht_wer)
    allsSoundArray.append(mse_guuuut)
    allsSoundArray.append(mse_gut_wunderbar)
    allsSoundArray.append(mse_gut_das_war_ja_das_hier)
    allsSoundArray.append(mse_des_seh_ich_jetzt_unproblematisch)
    allsSoundArray.append(mse_des_passt)
    allsSoundArray.append(mse_des_muess_mer_gucken)
    allsSoundArray.append(mse_aehm)
    allsSoundArray.append(MSE_Und_ich_sag_aber_ok)
    allsSoundArray.append(MSE_Die_Katze_im_Sack)
    allsSoundArray.append(MSE_Mein_Name_is_ehm)
    allsSoundArray.append(halloMatze)
    allsSoundArray.append(halloWillkommenMatze)
    allsSoundArray.append(DaswillwohldurchdachtseinMatze)
    allsSoundArray.append(fabiankuschkeMatze)
    allsSoundArray.append(meinNameistMathiasSeipel)
    allsSoundArray.append(smartMatze)
    allsSoundArray.append(unserslogan)
    
    allsSoundArray.append(nlu_nicht_vorher_hin)
    allsSoundArray.append(nlu_allein_hinbekommen_wuerdet)
    allsSoundArray.append(nlu_bekommen_wir_nicht_vorher_hin)
    allsSoundArray.append(nlu_danke)
    allsSoundArray.append(nlu_gut_das_wir_das_aufnehmen)
    allsSoundArray.append(nlu_gut2)
    allsSoundArray.append(nlu_guut)
    allsSoundArray.append(nlu_haben_sie_sonst_no_was)
    allsSoundArray.append(nlu_herr_seipel)
    allsSoundArray.append(nlu_is_halt_so)
    allsSoundArray.append(nlu_jap)
    allsSoundArray.append(nlu_mathias)
    allsSoundArray.append(nlu_montag_gemeinsam)
    allsSoundArray.append(nlu_muess_mer_damit_leben)
    allsSoundArray.append(nlu_muess_mer_mit_umgehen)
    allsSoundArray.append(nlu_okay2)
    allsSoundArray.append(nlu_ordentlich_dokumentiert)
    allsSoundArray.append(nlu_perfekt)
    allsSoundArray.append(nlu_ah_okay)
    allsSoundArray.append(nlu_alles_nicht_so_dramatisch)
    allsSoundArray.append(nlu_am_montag_passiert)
    allsSoundArray.append(nlu_des_Bekommen_wir_hin)
    allsSoundArray.append(nlu_direkt_loslegen)
    allsSoundArray.append(nlu_genau)
    allsSoundArray.append(nlu_genau2)
    allsSoundArray.append(nlu_gut)
    allsSoundArray.append(nlu_haha)
    allsSoundArray.append(nlu_ja_des_versteh_ich)
    allsSoundArray.append(nlu_ja)
    allsSoundArray.append(nlu_jaja)
    allsSoundArray.append(nlu_jap_dann_ist_es_halt_so)
    allsSoundArray.append(nlu_tututu)
    
    
    allsSoundArray.append(leidernochnicht)
    allsSoundArray.append(GenauFabi)
    allsSoundArray.append(JagernedochFabi)
    allsSoundArray.append(MaschineFabi)
    allsSoundArray.append(NichtperfektaberesreichtFabi)
    allsSoundArray.append(SovieldazuFabi)
    allsSoundArray.append(unddasmacheichjetzteinfachmalFabi)
    allsSoundArray.append(Konsultant)
    
    allsSoundArray.append(findeEineLoesung)
    allsSoundArray.append(echtJetzt)
    allsSoundArray.append(okay)
    allsSoundArray.append(EsTutMirLeid)
    allsSoundArray.append(EsTutMirLeidPocahontas)
    allsSoundArray.append(IfYoureHappy)
    allsSoundArray.append(IfYoureHappyClap)
    allsSoundArray.append(nlu_meeting)
    allsSoundArray.append(mse_NochFragen)
    allsSoundArray.append(mse_3)
    allsSoundArray.append(VerstehIchNichtKurz)
    allsSoundArray.append(VerstehIchNichtLang)
    allsSoundArray.append(CantinaBand)
    allsSoundArray.append(QuatschMerkschSelber)
    allsSoundArray.append(Layla)
    
    
    //MARK: Add to their arrays
    
    ploSoundArray.append(hallohieristPascal)
    ploSoundArray.append(halloPascalkurz)
    ploSoundArray.append(halloPascalvonkuk)
    ploSoundArray.append(PLO_aehm)
    
    mseSoundArray.append(mse_danke_nlu_schoenes_we)
    mseSoundArray.append(mse_dankeschoen_mit_nlu)
    mseSoundArray.append(mse_dann_mach_mer_des_doch_so)
    mseSoundArray.append(mse_ich_muss_aufs_klo)
    mseSoundArray.append(mse_ich_muss_aufs_klo_und_aufnehmen)
    mseSoundArray.append(mse_mathias_seipel)
    mseSoundArray.append(mse_tschuess)
    mseSoundArray.append(mse_wunderbar)
    mseSoundArray.append(mse_zum_naechsten_punkt)
    mseSoundArray.append(mse_so_aehm)
    mseSoundArray.append(mse_richtig)
    mseSoundArray.append(mse_nur_bedingt_gemacht)
    mseSoundArray.append(mse_nochmal_angucken)
    mseSoundArray.append(mse_jaah)
    mseSoundArray.append(mse_ich_weiss_jetzt_nicht_wer)
    mseSoundArray.append(mse_guuuut)
    mseSoundArray.append(mse_gut_wunderbar)
    mseSoundArray.append(mse_gut_das_war_ja_das_hier)
    mseSoundArray.append(mse_des_seh_ich_jetzt_unproblematisch)
    mseSoundArray.append(mse_des_passt)
    mseSoundArray.append(mse_des_muess_mer_gucken)
    mseSoundArray.append(mse_aehm)
    mseSoundArray.append(MSE_Und_ich_sag_aber_ok)
    mseSoundArray.append(MSE_Die_Katze_im_Sack)
    mseSoundArray.append(MSE_Mein_Name_is_ehm)
    mseSoundArray.append(halloMatze)
    mseSoundArray.append(halloWillkommenMatze)
    mseSoundArray.append(DaswillwohldurchdachtseinMatze)
    mseSoundArray.append(fabiankuschkeMatze)
    mseSoundArray.append(meinNameistMathiasSeipel)
    mseSoundArray.append(smartMatze)
    mseSoundArray.append(unserslogan)
    mseSoundArray.append(mse_NochFragen)
    mseSoundArray.append(mse_3)
    
    nluSoundArray.append(nlu_nicht_vorher_hin)
    nluSoundArray.append(nlu_allein_hinbekommen_wuerdet)
    nluSoundArray.append(nlu_bekommen_wir_nicht_vorher_hin)
    nluSoundArray.append(nlu_danke)
    nluSoundArray.append(nlu_gut_das_wir_das_aufnehmen)
    nluSoundArray.append(nlu_gut2)
    nluSoundArray.append(nlu_guut)
    nluSoundArray.append(nlu_haben_sie_sonst_no_was)
    nluSoundArray.append(nlu_herr_seipel)
    nluSoundArray.append(nlu_is_halt_so)
    nluSoundArray.append(nlu_jap)
    nluSoundArray.append(nlu_mathias)
    nluSoundArray.append(nlu_montag_gemeinsam)
    nluSoundArray.append(nlu_muess_mer_damit_leben)
    nluSoundArray.append(nlu_muess_mer_mit_umgehen)
    nluSoundArray.append(nlu_okay2)
    nluSoundArray.append(nlu_ordentlich_dokumentiert)
    nluSoundArray.append(nlu_perfekt)
    nluSoundArray.append(nlu_ah_okay)
    nluSoundArray.append(nlu_alles_nicht_so_dramatisch)
    nluSoundArray.append(nlu_am_montag_passiert)
    nluSoundArray.append(nlu_des_Bekommen_wir_hin)
    nluSoundArray.append(nlu_direkt_loslegen)
    nluSoundArray.append(nlu_genau)
    nluSoundArray.append(nlu_genau2)
    nluSoundArray.append(nlu_gut)
    nluSoundArray.append(nlu_haha)
    nluSoundArray.append(nlu_ja_des_versteh_ich)
    nluSoundArray.append(nlu_ja)
    nluSoundArray.append(nlu_jaja)
    nluSoundArray.append(nlu_jap_dann_ist_es_halt_so)
    nluSoundArray.append(nlu_tututu)
    nluSoundArray.append(nlu_meeting)
    
    
    fkuSoundArray.append(leidernochnicht)
    fkuSoundArray.append(GenauFabi)
    fkuSoundArray.append(JagernedochFabi)
    fkuSoundArray.append(MaschineFabi)
    fkuSoundArray.append(NichtperfektaberesreichtFabi)
    fkuSoundArray.append(SovieldazuFabi)
    fkuSoundArray.append(unddasmacheichjetzteinfachmalFabi)
    fkuSoundArray.append(Konsultant)
    
    esoSoundArray.append(echtJetzt)
    esoSoundArray.append(findeEineLoesung)
    esoSoundArray.append(okay)
    
    esoSoundArray = esoSoundArray.sorted(by: { $0.soundName < $1.soundName })
    nluSoundArray = nluSoundArray.sorted(by: { $0.soundName < $1.soundName })
    mseSoundArray = mseSoundArray.sorted(by: { $0.soundName < $1.soundName })
    ploSoundArray = ploSoundArray.sorted(by: { $0.soundName < $1.soundName })
    fkuSoundArray = fkuSoundArray.sorted(by: { $0.soundName < $1.soundName })
    
    
    
}


func saveFavoritesLocal(){
    
    let encoder = PropertyListEncoder()
    let fileURL = cachesURL.appendingPathComponent("favorites").appendingPathExtension("plist")
    do{
        let data = try encoder.encode(favSoundsArray)
        try data.write(to: fileURL)
    }catch{
        print("Error saving dict: \(error)")
    }
    
}


func getFavsLocal(){
    if favSoundsArray.count == 0 {
        let fileURL = cachesURL.appendingPathComponent("favorites").appendingPathExtension("plist")
        let filePath = fileURL.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            if let data = try? Data(contentsOf: fileURL){
                let decoder = PropertyListDecoder()
                do{
                    favSoundsArray = try decoder.decode([SoundModel].self, from: data)
                    favSoundsArray = favSoundsArray.sorted(by: { $0.soundName < $1.soundName })
                }catch{
                    print("Error reading: \(error)")
                }
            }else{
                print("no data")
            }
        }else{
            print("favorites not exist")
        }
    }else{
        print("products in products dict vorhanden")
    }
}

//MARK: JGProgressHUDs
func showHudError(inView: UIViewController, text: String, delay: Double){
    let hud = JGProgressHUD()
    hud.textLabel.text = text
    hud.indicatorView = JGProgressHUDErrorIndicatorView()
    hud.show(in: inView.view, animated: true)
    hud.dismiss(afterDelay: delay)
}
func showHudSuccess(inView: UIViewController, text: String, delay: Double){
    let hud = JGProgressHUD()
    hud.textLabel.text = text
    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
    hud.show(in: inView.view, animated: true)
    hud.dismiss(afterDelay: delay)
}


enum TargetDevice {
    case nativeMac
    case iPad
    case iPhone
    case iWatch
    
    public static var currentDevice: Self {
        var currentDeviceModel = UIDevice.current.model
        #if targetEnvironment(macCatalyst)
        currentDeviceModel = "nativeMac"
        #elseif os(watchOS)
        currentDeviceModel = "watchOS"
        #endif
        
        if currentDeviceModel.starts(with: "iPhone") {
            return .iPhone
        }
        if currentDeviceModel.starts(with: "iPad") {
            return .iPad
        }
        if currentDeviceModel.starts(with: "watchOS") {
            return .iWatch
        }
        return .nativeMac
    }
}


extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        let CounterClockwiseOrClockwise = Bool.random()
        if CounterClockwiseOrClockwise {
            rotation.toValue = Double.pi * 2
        }else{
            rotation.toValue = Double.pi * -2
        }
        let randSpend = Double.random(in: 1..<4)
        rotation.duration = randSpend
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}



//MARK: Gif


import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}
