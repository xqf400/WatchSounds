//
//  Sounds.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 12.04.22.
//

import Foundation
import MediaPlayer

let soundVolume:Float = 1
var playerOrg: AVAudioPlayer?
var settedDaysTill : Int = 0

/*
let IfYoureHappy = SoundModel(soundId: 49, soundName: "If Youre Happy", soundImage: "IfYoureHappy.png", soundFile: "IfYoureHappyShort", soundVolume: 1.0)
let EsTutMirLeidPocahontas = SoundModel(soundId: 48, soundName: "Es Tut Mir Leid", soundImage: "EsTutMirLeid.png", soundFile: "EsTutMirLeidPocahontas", soundVolume: 1.0)
let Iloveit = SoundModel(soundId: 37, soundName: "I love it", soundImage: "Iloveit.png", soundFile: "Iloveit", soundVolume: 1.0)
let lollipop_kurz = SoundModel(soundId: 42, soundName: "Lollipop kurz", soundImage: "lollipop.png", soundFile: "lollipop_kurz", soundVolume: 1.0)
let lollipop_long = SoundModel(soundId: 43, soundName: "Lollipop long", soundImage: "lollipop.png", soundFile: "Lollipop_long", soundVolume: 1.0)
let lollipop1 = SoundModel(soundId: 44, soundName: "Lollipop 1", soundImage: "lollipop.png", soundFile: "Lollipop1", soundVolume: 1.0)
let lollipop2 = SoundModel(soundId: 45, soundName: "Lollipop 2", soundImage: "lollipop.png", soundFile: "Lollipop2", soundVolume: 1.0)
let lollipop_pop = SoundModel(soundId: 46, soundName: "Lollipop pop", soundImage: "lollipop.png", soundFile: "Lollipop_pop", soundVolume: 1.0)
let IDontcare = SoundModel(soundId: 36, soundName: "I Dont care", soundImage: "IDontcare.png", soundFile: "IDontcare", soundVolume: 1.0)

let nlu_am_montag_passiert = SoundModel(soundId: 160, soundName: "montag passiert", soundImage: "nils.png", soundFile: "nlu_am_montag_passiert", soundVolume: 1)
let nlu_alles_nicht_so_dramatisch = SoundModel(soundId: 161, soundName: "nicht so dramatisch", soundImage: "nils.png", soundFile: "nlu_alles_nicht_so_dramatisch", soundVolume: 1)
let nlu_danke = SoundModel(soundId: 168, soundName: "danke", soundImage: "nils.png", soundFile: "nlu_danke", soundVolume: 1)
let nlu_haha = SoundModel(soundId: 154, soundName: "haha", soundImage: "nils.png", soundFile: "nlu_haha", soundVolume: 1)
let nlu_tututu = SoundModel(soundId: 164, soundName: "tututu", soundImage: "nils.png", soundFile: "nlu_tututu", soundVolume: 1)

let mse_dann_mach_mer_des_doch_so = SoundModel(soundId: 290, soundName: "mach mer des doch so", soundImage: "matze1.gif", soundFile: "mse_dann_mach_mer_des_doch_so", soundVolume: 1)
let smartMatze = SoundModel(soundId: 269, soundName: "smart", soundImage: "matze.png", soundFile: "smartMatze", soundVolume: 1)
let mse_richtig = SoundModel(soundId: 273, soundName: "richtig", soundImage: "matze.png", soundFile: "mse_richtig", soundVolume: 1)
let mse_wunderbar = SoundModel(soundId: 295, soundName: "wunderbar", soundImage: "matze.png", soundFile: "mse_wunderbar", soundVolume: 1)
let mse_guuuut = SoundModel(soundId: 278, soundName: "guuuut", soundImage: "matze.png", soundFile: "mse_guuuut", soundVolume: 1)
let MSE_Und_ich_sag_aber_ok = SoundModel(soundId: 285, soundName: "ich sag aber ok", soundImage: "matze.png", soundFile: "MSE_Und_ich_sag_aber_ok", soundVolume: 1)

let halloPascalkurz = SoundModel(soundId: 141, soundName: "hallo", soundImage: "pascal.png", soundFile: "halloPascalkurz", soundVolume: 1)
let MSE_Die_Katze_im_Sack = SoundModel(soundId: 286, soundName: "die Katze im Sack", soundImage: "matze.png", soundFile: "MSE_Die_Katze_im_Sack", soundVolume: 1)
let mse_3 = SoundModel(soundId: 296, soundName: "3", soundImage: "matze.png", soundFile: "mse3", soundVolume: 1)
let mse_NochFragen = SoundModel(soundId: 297, soundName: "Noch Fragen?", soundImage: "matze.png", soundFile: "mseNochFragen", soundVolume: 1)
let nlu_meeting = SoundModel(soundId: 183, soundName: "meeting", soundImage: "nils.png", soundFile: "nlumeeting", soundVolume: 1)



let denken = SoundModel(soundId: 0, soundName: "Denken", soundImage: "denken.png", soundFile: "denken", soundVolume: soundVolume)
let excited_kurz = SoundModel(soundId: 9, soundName: "Excited kurz", soundImage: "excited.png", soundFile: "excited_kurz", soundVolume: soundVolume)
let JedeZelleKurz = SoundModel(soundId: 20, soundName: "Jede Zelle Kurz", soundImage: "jedezelle.png", soundFile: "JedeZelleKurz", soundVolume: soundVolume)
let mimimi = SoundModel(soundId: 11, soundName: "Mimimi", soundImage: "mimimi.png", soundFile: "mimimi", soundVolume: soundVolume)
let miracolikurz = SoundModel(soundId: 26, soundName: "Miracoli kurz", soundImage: "miracoli.png", soundFile: "miracolikurz", soundVolume: soundVolume)
let SchoenerTagStuttgarter = SoundModel(soundId: 13, soundName: "Schoener Tag Stuttgarter", soundImage: "schoenertagstuttgarter.png", soundFile: "SchoenerTagStuttgarter", soundVolume: soundVolume)
let Spass__kurz = SoundModel(soundId: 1, soundName: "Spass kurz", soundImage: "spass.png", soundFile: "Spass__kurz", soundVolume: soundVolume)
let Tag__kurz = SoundModel(soundId: 4, soundName: "Tag kurz", soundImage: "schoenertag.png", soundFile: "Tag__kurz", soundVolume: soundVolume)
let tellmewhylang = SoundModel(soundId: 15, soundName: "tell me why lang", soundImage: "tellmewhy.png", soundFile: "tellmewhylang", soundVolume: soundVolume)
let tellmewhykurz = SoundModel(soundId: 16, soundName: "tell me why kurz", soundImage: "tellmewhy.png", soundFile: "tellmewhykurz", soundVolume: soundVolume)
let vielleichtsekt = SoundModel(soundId: 38, soundName: "vielleicht sekt", soundImage: "vielleichtsekt.png", soundFile: "vielleichtsekt", soundVolume: soundVolume)
let VerstehIchNichtKurz = SoundModel(soundId: 51, soundName: "Versteh Ich Nicht Kurz", soundImage: "VerstehIchNicht.png", soundFile: "VerstehIchNichtKurz", soundVolume: 1.0)

let delfin = SoundModel(soundId: 8, soundName: "Delfin", soundImage: "delfin.png", soundFile: "Delfin", soundVolume: soundVolume)
let esel = SoundModel(soundId: 31, soundName: "esel", soundImage: "esel.png", soundFile: "esel", soundVolume: soundVolume)
let gehdochzuhause = SoundModel(soundId: 17, soundName: "geh doch zu hause", soundImage: "gehdochheim.png", soundFile: "gehdochzuhause", soundVolume: soundVolume)
let HitMeBabyOneMoreTime = SoundModel(soundId: 29, soundName: "Hit Me Baby One More Time", soundImage: "HitMeBabyOneMoreTime.png", soundFile: "HitMeBabyOneMoreTime", soundVolume: soundVolume)
let imperialmarch = SoundModel(soundId: 19, soundName: "Imperial March", soundImage: "imperialmarch.png", soundFile: "imperialmarch", soundVolume: soundVolume)
let jajalang = SoundModel(soundId: 24, soundName: "Was heisst hier jaja lang", soundImage: "jaja.png", soundFile: "jajalang", soundVolume: soundVolume)
let jajakurz = SoundModel(soundId: 25, soundName: "Was heisst hier jaja", soundImage: "jaja.png", soundFile: "jajakurz", soundVolume: soundVolume)
let Mallezuruck = SoundModel(soundId: 10, soundName: "Malle zurück", soundImage: "Mallezuruck.png", soundFile: "Mallezuruck", soundVolume: soundVolume)
let wasmachensachen = SoundModel(soundId: 40, soundName: "was machen sachen", soundImage: "wasmachensachen.png", soundFile: "wasmachensachen", soundVolume: soundVolume)
let CantinaBand = SoundModel(soundId: 40, soundName: "Cantina Band", soundImage: "CantinaBand.png", soundFile: "CantinaBand", soundVolume: soundVolume)
let QuatschMerkschSelber = SoundModel(soundId: 54, soundName: "Merksch selber", soundImage: "QuatschMerkschSelber.png", soundFile: "QuatschMerkschSelber", soundVolume: soundVolume)
 let imperialmarchLong = SoundModel(soundId: 56, soundName: "Imperial March Long", soundImage: "ImperialMarchLong.png", soundFile: "ImperialMarchLong", soundVolume: soundVolume)
 */
let Layla = SoundModel(soundId: 55, soundName: "Layla kurz", soundImage: "Layla.png", soundFile: "LaylaKurz", soundVolume: soundVolume)


func getDaysBetweenDates(from date1:Date, to date2: Date) -> Int{
    let calendar = Calendar.current
    let date1 = calendar.startOfDay(for: date1)
    let date2 = calendar.startOfDay(for: date2)

    let components = calendar.dateComponents([.day], from: date1, to: date2)
    let days = components.day! - 1
    return days
}
