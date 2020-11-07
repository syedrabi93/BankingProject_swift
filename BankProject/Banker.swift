//
//  Banker.swift
//  BankProject
//
//  Created by S, Syed Rabiyama on 02/11/20.
//  Copyright © 2020 Rabiyama, Syed. All rights reserved.
//

import Foundation

//Class to handle Banker details
class Banker
{
    var bankerID: String
    var bankerName: String
    
    //initialisation
    init (bankerID: String , bankerName: String){
        self.bankerID = bankerID
        self.bankerName = bankerName
    }
    
    //checks if the logged in banker is an active employee
    static func  isBankerExist(user : String)-> Bool
    {
        if (AllBankers.firstIndex(where: {$0.bankerID == user}) != nil) == true {
            return true
        }
        return false
    }
    
    /* function to preload the banker details if the file is not empty
     * if not load the customer login data from from here (testing purpose)
     */
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
    
    //Function to finally update the file with the data while leaving the application
    //loads the data from objects to the file for permanent storage
    
    static func saveBankerAccounts () -> Void {
        var text = "";
        for user in AllBankers {
            text.append(contentsOf: "\(user.bankerID),\(user.bankerName)\n") ;
        }
        FileReader.saveToFile(fileName: "Bankers.txt", content: text);
        
    }
}
