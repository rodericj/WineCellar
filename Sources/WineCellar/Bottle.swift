//
//  File.swift
//  
//
//  Created by Roderic Campbell on 11/23/20.
//

import Foundation

enum WineType: String, Decodable {
    case red = "Red"
    case white = "White"
    case whiteSweetDessert = "White - Sweet/Dessert"
}

public struct Bottle: Decodable {
    let wineID: String
    let title: String
    let location: String
    let price: Float
    let vintage: String
    let quantity: Int
    let wineBarcode: String
    let size: String
    let valuation: Float

    let currency: String
    let locale: String
    let country: String
    let region: String
    let subRegion: String
    let appellation: String
    let producer: String
    let sortProducer: String
    let type: WineType // decodable?

    let varietal: String
    let masterVarietal: String
    let designation: String
    let vineyard: String
    let ct: String?
    let upc: String?
    let beginConsume: Int?
    let endConsume: Int?

    enum CodingKeys: String, CodingKey {
        case wineID = "iWine"
        case title = "Wine"
        case location = "Location"
        case price = "Price"
        case vintage = "Vintage"
        case quantity = "Quantity"
        case wineBarcode = "WineBarcode"
        case size = "Size"
        case valuation = "Valuation"
        case currency = "Currency"
        case locale = "Locale"
        case country = "Country"
        case region = "Region"
        case subRegion = "SubRegion"
        case appellation = "Appellation"
        case producer = "Producer"
        case sortProducer = "SortProducer"
        case type = "Type"
        case varietal = "Varietal"
        case masterVarietal = "MasterVarietal"
        case designation = "Designation"
        case vineyard = "Vineyard"
        case ct = "CT"
        case upc = "UPC"
        case beginConsume = "BeginConsume"
        case endConsume = "EndConsume"
    }
}

extension Bottle: CustomStringConvertible {
    public var description: String {
        return "\n\(title) \(price) \(valuation) \(quantity), \(wineBarcode) \(size)"
    }
}
