//
//  Product.swift
//  GoToMeal
//
//  Created by Clement Legros on 31/05/2022.
//

import Foundation


class Plat {
    
    let id:String;
    let nom:String;
    let image:String;
    var description:String{
        return "\(nom)";
    }
    
    init(id:String, nom:String, image:String) {
        self.id = id;
        self.nom = nom;
        self.image = image;
    }
    
}
