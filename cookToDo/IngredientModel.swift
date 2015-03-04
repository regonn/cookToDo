//
//  itemModel.swift
//  cookList
//
//  Created by 田上健太 on 2015/02/24.
//  Copyright (c) 2015年 SonicGarden. All rights reserved.
//

import Foundation


class IngredientModel {
    var tableName = "ingredients"
    
    init() {
        let (tb, err) = SD.existingTables()
        if !contains(tb, tableName) {
            if let err =
                SD.createTable(tableName, withColumnNamesAndTypes: [ "Html": .StringVal, "CellHeight": .IntVal ]){
                    
            } else {
                
            }
        }
        println(SD.databasePath())
    }
    
    func add(html: String) -> Int{
        var result: Int? = nil
        println("Add ingredient")
        println(html)
        if let err = SD.executeChange("INSERT INTO ? (Html, CellHeight) VALUES(?, ?)", withArgs: [ tableName, html, Int(0) ]){
            println(err)
        } else {
            let (id, err) = SD.lastInsertedRowID()
            if err != nil {
                
            }else{
                result = Int(id)
            }
        }
        println(result!)
        return result!
    }
    
    
    func delete(id: String){
        if let err = SD.executeChange("DELETE FROM ? WHERE ID = ?", withArgs: [tableName, id]){
        }else{
            println("\(id) was deleted.")
        }
    }

    func updateCellHeight(id: Int, cellHeight: Int) -> Int{
        if let err = SD.executeChange("UPDATE ? SET CellHeight = ? WHERE ID = ?", withArgs: [tableName, cellHeight, id]) {
        } else {
            println("update CellHeight:\(cellHeight)")
        }
        return Int(cellHeight)
    }
    
    func all() -> NSMutableArray {
        var ingredients = NSMutableArray()
        println(ingredients.count)
        let (resultSet, err) = SD.executeQuery("SELECT * FROM ? ORDER BY ID DESC", withArgs: [tableName])
        if err != nil {
            println(err)
        } else {
            for row in resultSet {
                if let id = row["ID"]?.asInt() {
                    var ingredient = Ingredient()
                    var html = row["Html"]?.asString()
                    var cellHeight = row["CellHeight"]?.asInt()
                    ingredient.cellHeight = cellHeight!
                    ingredient.html = html!
                    ingredient.id = id
                    ingredients.addObject(ingredient)
                }
            }
        }
        return ingredients
    }

    func deleteAll(){
        if let err = SD.executeChange("DELETE FROM ?", withArgs: [tableName]){
        }else{
        }
    }
}