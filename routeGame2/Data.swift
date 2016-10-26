//
//  DataServices.swift
//  routeGame2
//
//  Created by Lewis Black on 18/08/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import Foundation

class DataCheck {
    let firstApp = [Data().data1, Data().data2, Data().data5, Data().data6, Data().data11, Data().data15, Data().data14]
}

class Data {
    
    //Data,translation, title, hint
    
    let data1 = ["Rome, Home of the Coliseum, Stockholm, Capital of Sweden, Vienna, Capital of Austria, Minsk, Capital of Belarus - Where Phoebes boyfriend David goes in Friends, Brussels, Capital of Belgium, Sarajevo, Capital of Bosnia, Bern, Capital of Switzerland, Zagreb, Capital of Croatia, Prague, Capital of Czech Republic, Copenhagen, Capital of Denmark,Helsinki, Capital of Finland, Paris, Home of the Eiffel Tower, Madrid, Capital of Spain, Dublin, Capital of the Republic of Ireland, Athens, Capital of Greece - Home of the Pantheon, Monaco, Capital of small Mediterranean city state which it shares the name of, Reykjavik, Capital of Iceland, Amsterdam, Famous for it's canals and red light district, Oslo, Capital of Norway, Warsaw, Capital of Poland, Lisbon, Capital of Portugal, Bucharest, Capital of Romania, Bratislava, Capital of Slovakia, Moscow, Capital of Russia, Tallinn , Capital of Estonia - Has a double L and a double N ", false, "Capitals of Europe", true] as [Any]
    
    let data2 = ["Arizona, Arkansas, Connecticut, Delaware, Idaho, Indiana, Iowa, NewHampshire, Louisiana, Maine, Oklahoma, Maryland, Michigan, Minnesota, Missouri, Ohio, Utah, Virginia, Washington, Wisconsin, Wyoming, California", false, "American States", false] as [Any]
    
    let data3 = ["cerveza, beer, galleta, biscuit, canela, cinnamon, aguardiente, brandy, arroz, rice, chorizo, sausage, azúcar, sugar, vinagre, vinegar, agua, water, vino, wine, yogurt, yogurt, pan, bread, mantequilla, butter, bollo, cake, margarina, margerine, queso, cheese, café, coffee, huevo, egg, pescado, fish, jamón, ham, helado, ice cream, zumo, juice, leche, milk, mostaza, mustard,  el aceite de oliva, olive oil, pimienta, pepper", true, "Foods In Spanish", false] as [Any]
    
    let data4 = ["Micah Richards, Wayne Bridge, James Milner, Edin Džeko, Adam Johnson, Stefan Savić, Gareth Barry, Owen Hargreaves, Kolo Touré, Costel Pantilimon, Joe Hart, Samir Nasri, Carlos Tevez, Nigel de Jong, Mario Balotelli", false, "Manchester City Footballers", false] as [Any] //Who won the 11/12 Premier League and then got sold
    
    let data5 = ["France, Belgium, Netherlands, Spain, Czech Republic, Luxemburg, Denmark, United States, Switzerland, Jersey, Norway, Hungary, Slovakia, Italy, Vatican City, Slovenia, Croatia, Morocco, United Arab Emirates, India", false, "Countries In Order Lewis Visited Them", false] as [Any]
    
    let data6 = ["die Pommes, Chips, der Reis, Rice, die Nudel, Pasta, der Kaffee, Coffee, der Thunfisch, Tuna, der Lachs, Salmon,  das Mehl, Flour, der Honig, Honey, die Nuss, Nut, das Brot, Bread, der Käse, Cheese, die Zwiebel, Onion,  die Bohnen, Beans, die Erbsen, Peas, die Kartoffel, Potato, die Zucchini, Courgette, die Paprika, Pepper, der Speck, Bacon, das Hähnchen, Chicken", true, "German Food", false ] as [Any]
    
    let data7 = ["Pommes, Chips, Reis, Rice, Nudel, Pasta, Kaffee, Coffee, Thunfisch, Tuna, Lachs, Salmon, Mehl, Flour, Honig, Honey, Nuss, Nut, Brot, Bread,Käse, Cheese, Zwiebel, Onion, Bohnen, Beans, Erbsen, Peas, Kartoffel, Potato, Zucchini, Courgette, Paprika, Pepper, Speck, Bacon, Hähnchen, Chicken, Pfefferminztee, Peppermint Tea, Schweinefleisch, Pork, Öl, Oil, Knoblauch, Garlic, Wassermelone, Watermelon, Birne, Pear", true, "German Food", false ] as [Any]
    
    let data8 = ["schüchtern, shy, angeberisch, boastful, höflich, polite,stolz, proud,klug, clever,  doof, stupid,mies, rotten,unternehmungslustig, adventurous, eifersüchtig, jealous, ehrlich, honest, ernst, serious, geduldig, patient, gemein, mean,  launisch, moody, leise, quiet,  nett, nice, neugierig, curious ,böse, evil,  selbstbewusst, self-confident,  streng, strict, sympathisch, likeable, lebhaft, lively", true, "German Adjectives", false ] as [Any]
    
    let data9 = ["höflich, polite, leise, quiet, sympathisch, likeable, klug, clever, selbstbewusst, self-confident, streng, strict,  doof, stupid, mies, rotten, nett, nice, unternehmungslustig, adventurous, eifersüchtig, jealous, ehrlich, honest, ernst, serious, geduldig, patient, gemein, mean,  launisch, moody, schüchtern, shy, neugierig, curious ,böse, evil, stolz, proud, lebhaft, lively, angeberisch, boastful", true, "German adjectives", false ] as [Any]
    
    let data10 = ["Burj Khalifa, CN Tower, Willis Tower, World Trade Centre, Empire State Building, Millau Viaduct, Chrystler Building, Eiffel Tower, The Shard, The Gherkin, Beetham Tower, Great Pyramid, Pharos Lighthouse, Big Ben", false, "Buildings In Height Order", false] as [Any]
    
    let data11 = ["Argentina, Bolivia, Brazil, Chile, Colombia, Ecuador, Mexico, Guyana, Paraguay, Peru,  Uruguay, Venezuela, Belize, Costa Rica, El Salvador, French Guiana, Guatemala, Honduras, Panama, United States Of America, Canada", false, "Countries Of Mainland America", false] as [Any] // except nicauragua and suriname all of mainland america
    
    let data12 = ["Cambodia, Cameroon, Canada, Cape Verde, Cayman Islands, Central African Republic, Chad, Chile, Colombia, Comoros, Democratic Republic Congo, China, Costa Rica, Cote d'Ivoire, Croatia, Cuba, Cyprus, Czech Republic", false, "Countries Beginning With 'C'", false] as [Any]
    
    let data13 = ["Samoa, San Marino, Saudi Arabia, Senegal, Serbia, Seychelles, Singapore, Slovakia, Slovenia, Solomon Islands, Somalia, South Africa, Spain, Sri Lanka, St Lucia, Sudan, Suriname, Swaziland, Sweden, Switzerland, Syria", false, "Countries Beginning With 'S'", false] as [Any] //except a few st kitts, st vincent and more

    let data14 = ["Tyrion Lannister, Intelligent alcoholic dwarf, Jon Snow, Bastard hero at the wall, Daenerys Targaryen, Mother of dragongs, Cersei Lannister, Joffreys mother, Sansa Stark, Ginger daughter of Ned and Catelyn, Arya Stark, Tomboy daughter of Ned and Catelyn, Jaime Lannister, Cersei's twin brother and lover, Theon Greyjoy, Otherwise known as Reek, Samwell Tarly, Jon's loveable best friend, Jorah Mormont, Daenerys guardian, Littlefinger, Real name Petyr Baelish, Ned Stark, Beheaded leader of Winterfell, Brienne, Tall female warrior, Davos, The onion knight; right hand man to Stannis, Tywin Lannister, Killed by his dwarf son while on the toilet", false, "Game Of Thrones Characters By Mentions", true] as [Any]
    
    let data15 = ["Harry Potter, The main character of the series, Ron Weasley, Harry's best male friend, Hermione Granger, Harry's best female friend, Albus Dumbledore, Headmaster of Hogwarts, Rubeus Hagrid, Hogwart's groundskeeper, Severus Snape, Hogwart's potionmaster, Voldemort, The main villian of the series, Sirius Black, Harry's godfather, Draco Malfoy, Harry's nemisis in slytherin house, Fred Weasley, Twins with George, Remus Lupin, Defense against the dark arts professor in Harrys third year, Neville Longbottom, Loveable fellow member of Grythindor house, Arthur Weasley, Father of Ron, Ginny Weasley, Rons younger sister", false, "Harry Potter Characters By Mentions", true] as [Any]
    
   
    func randomiseData(_ array:Array<AnyObject>) -> Array<AnyObject> {
        let count = array.count
        var newArray = makeArrayOfAnswers(array[0] as! String)
        
        if array[1] as! Bool == true {
            for i in 0..<count where i % 2 == 0 {
                let j = Int(arc4random_uniform(UInt32(count - 1 )))
                if i != j {
                    swap(&newArray[i], &newArray[j])
                    swap(&newArray[i+1], &newArray[j+1])
                }
            }
        } else {
            for i in 0..<count {
                let j = Int(arc4random_uniform(UInt32(count - 1)))
                if i != j {
                    swap(&newArray[i], &newArray[j])
                }
            }
            
        }
        return newArray as Array<AnyObject>
    }
    
    func changeToDataString(_ withTranslation: String, dataUsed: Bool) -> String {
        var translationArray:Array<String>

        

        var newArray:[String] = []

        if dataUsed {
            translationArray = makeArrayOfAnswers(withTranslation)

            for i in 0..<translationArray.count where i % 2 == 0 {
                newArray.append(translationArray[i])
            }
        } else {
            translationArray = makeArrayOfHints(withTranslation)

            for i in 1..<translationArray.count where i % 2 == 1 {
                newArray.append(translationArray[i])
            }
        }

        let stringRepresentation:String = newArray.joined(separator: ", ")
        return stringRepresentation
    }
    
    
    
    func makeArrayOfAnswers(_ string:String) -> Array<String> {

        let stringWithOutSpaces = string.replacingOccurrences(of: " ", with: "")
        let stringWithOutCommas = stringWithOutSpaces.replacingOccurrences(of: ",", with: "")
        print(stringWithOutCommas.characters.count)
        //it's missing ROME!!!!
        let array = stringWithOutSpaces.components(separatedBy: ",")
        print(array.count)

        return array
    }
    
    func makeArrayOfHints(_ string:String) -> Array<String> {
        
        let stringWithOutCommas = string.replacingOccurrences(of: ", ", with: ",")
        let array = stringWithOutCommas.components(separatedBy: ",")
        
        return array
    }
}
