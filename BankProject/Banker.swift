//
//  Banker.swift
//  BankProject
//
//  Created by S, Syed Rabiyama on 02/11/20.
//  Copyright © 2020 Rabiyama, Syed. All rights reserved.
//

import Foundation

class Banker
{
    var bankerID: String
    var bankerName: String
    
    init (bankerID: String , bankerName: String){
        self.bankerID = bankerID
        self.bankerName = bankerName
    }
    
    static func  isBankerExist(user : String)-> Bool
    {
        if (AllBankers.firstIndex(where: {$0.bankerID == user}) != nil) == true {
            return true
        }
        return false
    }
    
    static func readUserBankers () -> Void {
        let fileName = "Bankers.txt";
        var text = """
        Kaur,Narindar
        Wajeeh,Wajeehullah
        """;
        let textFromFile = FileReader.readFromFile(fileName: fileName);
        if !textFromFile.isEmpty {
            text = textFromFile;
        }
        Helpers.convertTextToBankers(text: text);
        
    }
    
    static func saveBankerAccounts () -> Void {
        var text = "";
        for user in AllBankers {
            text.append(contentsOf: "\(user.bankerID),\(user.bankerName)\n") ;
        }
        FileReader.saveToFile(fileName: "Bankers.txt", content: text);
        
    }
}
