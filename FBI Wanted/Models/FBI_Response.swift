//
//  FBI_Response.swift
//  FBI Wanted
//
//  Created by Shamil Bayramli on 25.02.24.
//

import Foundation

struct FBIResponse: Codable
{
    let total: Int
    let page: Int
    let items: [FBIItem]
}

struct FBIImage: Codable
{
    let original: String?
}

struct FBIItem: Codable
{
    let title: String?
    let caution: String?
    let age_min: Int?
    let age_max: Int?
    let sex: String?
    let weight: String?
    let height_min: Int?
    let nationality: String?
    let images: [FBIImage]
    
    var cleanDetails: String {
        guard let caution = caution else {return "No Information."}
        
        return caution.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var getAge: String
    {
        let result = [age_min, age_max].compactMap { $0.map(String.init) }.joined(separator: " - ")
        
        if result == ""
        {
            return "UNKNOWN"
        }
        else
        {
            return result
        }
    }
    
    var getName: String
    {
        guard let title = title else {return "UNKNOWN"}
        
        if let index = title.firstIndex(of: "-") {
            return String(title[..<index])
        } else {
            return title
        }
    }
    
    var getSex: String
    {
        guard let sex = sex else {return "UNKNOWN"}
        
        return sex
    }
    
    var getWeight: String
    {
        guard let weight = weight else {return "UNKNOWN"}
        
        return weight
    }
    
    var getHeight: String
    {
        guard let height = height_min else {return "UNKNOWN"}
        
        //return String(height)
        return ("\(String(height)[String(height).startIndex])'\(String(height)[String(height).index(before: String(height).endIndex)])\"")
    }

    var getNationality: String
    {
        guard let nationality = nationality else {return "UNKNOWN"}
        
        return nationality
    }

    var getImage: String
    {
        guard let imageURL = images[0].original else {return ""}
        
        return imageURL
    }
}

