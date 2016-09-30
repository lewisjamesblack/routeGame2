//
//  DataServices.swift
//  routeGame2
//
//  Created by Lewis Black on 18/08/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import Foundation

class DataCheck {
    let firstApp = [Data().data1, Data().data2, Data().data5, Data().data10, Data().data11, Data().data12, Data().data13]
    
}

class Data {
    
    
    
    //Data
    
    let data1 = ["Rome, Stockholm, Vienna, Minsk, Brussels, Sarajevo, Bern, Zagreb, Prague, Copenhagen, Tallinn, Helsinki, Paris, Madrid, Berlin, Athens, Monaco, Reykjavik, Amsterdam, Oslo, Warsaw, Lisbon, Bucharest, Bratislava, Moscow",false, "Capitals of Europe"] as [Any]
    
    let data2 = ["Arizona, Arkansas, Connecticut, Delaware, Idaho, Indiana, Iowa, NewHampshire, Louisiana, Maine, Oklahoma, Maryland, Michigan, Minnesota, Missouri, Ohio, Utah, Virginia, Washington, Wisconsin, Wyoming, California",false, "American States"] as [Any]
    
    let data3 = ["cerveza, beer, galleta, biscuit, canela, cinnamon, aguardiente, brandy, arroz, rice, chorizo, sausage, azúcar, sugar, vinagre, vinegar, agua, water, vino, wine, yogurt, yogurt, pan, bread, mantequilla, butter, bollo, cake, margarina, margerine, queso, cheese, café, coffee, huevo, egg, pescado, fish, jamón, ham, helado, ice cream, zumo, juice, leche, milk, mostaza, mustard,  el aceite de oliva, olive oil, pimienta, pepper", true] as [Any]
    
    let data4 = ["Micah Richards, Wayne Bridge, James Milner, Edin Džeko, Adam Johnson, Stefan Savić, Gareth Barry, Owen Hargreaves, Kolo Touré, Costel Pantilimon, Joe Hart, Samir Nasri, Carlos Tevez, Nigel de Jong, Mario Balotelli", false, "Manchester City Footballers", "Who won the 11/12 Premier League and then got sold"] as [Any]
    
    let data5 = ["France, Belgium, Netherlands, Spain, Czech Republic, Luxemburg, Denmark, United States, Switzerland, Jersey, Norway, Hungary, Slovakia, Italy, Vatican City, Slovenia, Croatia, Morocco, United Arab Emirates, India", false, "Countries In Order Lewis Visited Them"] as [Any]
    
    let data6 = ["die Pommes, Chips, der Reis, Rice, die Nudel, Pasta,  der Kaffee, Coffee, der Thunfisch, Tuna, der Lachs, Salmon,  das Mehl, Flour, der Honig, Honey, die Nuss, Nut, das Brot, Bread, der Käse, Cheese, die Zwiebel, Onion,  die Bohnen, Beans, die Erbsen, Peas, die Kartoffel, Potato, die Zucchini, Courgette, die Paprika, Pepper, der Speck, Bacon, das Hähnchen, Chicken", true] as [Any]
    
    let data7 = ["Pommes, Chips, Reis, Rice, Nudel, Pasta, Kaffee, Coffee, Thunfisch, Tuna, Lachs, Salmon, Mehl, Flour, Honig, Honey, Nuss, Nut, Brot, Bread,Käse, Cheese, Zwiebel, Onion, Bohnen, Beans, Erbsen, Peas, Kartoffel, Potato, Zucchini, Courgette, Paprika, Pepper, Speck, Bacon, Hähnchen, Chicken, Pfefferminztee, Peppermint Tea, Schweinefleisch, Pork, Öl, Oil, Knoblauch, Garlic, Wassermelone, Watermelon, Birne, Pear", true] as [Any]
    
    let data8 = ["schüchtern, shy, angeberisch, boastful, höflich, polite,stolz, proud,klug, clever,  doof, stupid,mies, rotten,unternehmungslustig, adventurous, eifersüchtig, jealous, ehrlich, honest, ernst, serious, geduldig, patient, gemein, mean,  launisch, moody, leise, quiet,  nett, nice, neugierig, curious ,böse, evil,  selbstbewusst, self-confident,  streng, strict, sympathisch, likeable, lebhaft, lively", true] as [Any]
    
    let data9 = ["höflich, polite, leise, quiet, sympathisch, likeable, klug, clever, selbstbewusst, self-confident, streng, strict,  doof, stupid,mies, rotten, nett, nice, unternehmungslustig, adventurous, eifersüchtig, jealous, ehrlich, honest, ernst, serious, geduldig, patient, gemein, mean,  launisch, moody, schüchtern, shy, neugierig, curious ,böse, evil, stolz, proud, lebhaft, lively, angeberisch, boastful", true] as [Any]
    
    let data10 = ["Burj Khalifa, CN Tower, Willis Tower, World Trade Centre, Empire State Building, Millau Viaduct, Chrystler Building, Eiffel Tower, The Shard, The Gherkin, Beetham Tower, Great Pyramid, Pharos Lighthouse, Big Ben", false, "Buildings In Height Order"] as [Any]
    
    let data11 = ["Argentina, Bolivia, Brazil, Chile, Colombia, Ecuador, Mexico, Guyana, Paraguay, Peru,  Uruguay, Venezuela, Belize, Costa Rica, El Salvador, French Guiana, Guatemala, Honduras, Panama, United States Of America, Canada", false, "Countries Of Mainland America"] as [Any] // except nicauragua and suriname all of mainland america
    
    let data12 = ["Cambodia, Cameroon, Canada, Cape Verde, Cayman Islands, Central African Republic, Chad, Chile, Colombia, Comoros, Democratic Republic of the Congo, Costa Rica, Cote d'Ivoire, Croatia, Cuba, Cyprus, Czech Republic", false, "Countries Beginning With 'C'"] as [Any] // except china
    
    let data13 = ["Samoa, San Marino, Saudi Arabia, Senegal, Serbia, Seychelles, Singapore, Slovakia, Slovenia, Solomon Islands, Somalia, South Africa, Spain, Sri Lanka, St Lucia, Sudan, Suriname, Swaziland, Sweden, Switzerland, Syria", false, "Countries Beginning With 'S'"] as [Any] //except a few st kitts, st vincent and more

   
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
    
    func toDataString(_ withTranslation: String, dataUsed: Bool) -> String {
        let translationArray = makeArrayOfAnswers(withTranslation)
        // data used is basically if i use the data or I use the translation
        var difference:Int
        if dataUsed {
            difference = 0
        } else {
            difference = 1
        }
        
        var newArray:[String] = []
        for i in difference..<translationArray.count where i % 2 == 0 {
            newArray.append(translationArray[i])

        }
//        for var i = difference; i < translationArray.count; i = i + 2 {
//        }
//        
        let stringRepresentation = newArray.joined(separator: ", ")
        return stringRepresentation
    }
    
    func makeArrayOfAnswers(_ string:String) -> Array<String> {
        let stringWithOutSpaces = string.replacingOccurrences(of: " ", with: "")
        let stringWithOutCommas = stringWithOutSpaces.replacingOccurrences(of: ",", with: "")
        print(stringWithOutCommas.characters.count)
        let array = stringWithOutSpaces.components(separatedBy: ",")
        print(array.count)
        return array
    }
}
