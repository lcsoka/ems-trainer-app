//
//  DictionaryConvertable.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 07..
//

import Foundation

protocol DictionaryConvertable {
    func toDictionary() -> [String : Any]
}

extension DictionaryConvertable {
    func toDictionary() -> [String : Any] {
        let reflect = Mirror(reflecting: self)
        let children = reflect.children
        let dictionary = toAnyHashable(elements: children)
        return dictionary
    }
    
    func toAnyHashable(elements: AnyCollection<Mirror.Child>) -> [String : Any] {
        var dictionary: [String : Any] = [:]
        for element in elements {
            if let key = element.label {
                
                if let collectionValidHashable = element.value as? [AnyHashable] {
                    dictionary[key] = collectionValidHashable
                }
                
                if let validHashable = element.value as? AnyHashable {
                    dictionary[key] = validHashable
                }
                
                if let convertor = element.value as? DictionaryConvertable {
                    dictionary[key] = convertor.toDictionary()
                }
                
                if let convertorList = element.value as? [DictionaryConvertable] {
                    dictionary[key] = convertorList.map({ e in
                        e.toDictionary()
                    })
                }
            }
        }
        return dictionary
    }
}
