//
//  User.swift
//  BankProject
//
//  Created by Adarshdeep Singh on 01/11/20.
//  Copyright © 2020 Rabiyama, Syed. All rights reserved.
//

import Foundation;

enum UserType {
    case Banker
    case Customer
}


class Account {
    
    var username: String;
    var password: String;
    var type: UserType;
    init(username: String, password: String, type: UserType){
        self.username = username;
        self.password = password;
        self.type = type;
    }
    static func findUser(userName: String , type: UserType) -> Account? {
        let index = AllBankersAndCustomers.firstIndex(where: {$0.username == userName && $0.type == type});
        if(index == nil){
            return nil;
        }else {
            return AllBankersAndCustomers[index!];
        }
    }
  
    static func checkSignIn (type: UserType) -> Account? {
        print("Enter Username:");
        let username = readLine()!;
        print("Enter Password");
        let password = readLine()!;
        var currentUser: Account? = nil;
        for user in AllBankersAndCustomers {
            if user.password == password && user.username == username && user.type == type {
                currentUser = user;
                break;
            }
        }
        return currentUser;
    }
   
    static func readUserAccounts () -> Void {
        let fileName = "Users.txt";
        var text = """
        Syed,test1,Customer
        Adarsh,test2,Customer
        Kaur,test3,Banker
        Wajeeh,test4,Banker
        """;
        let textFromFile = FileReader.readFromFile(fileName: fileName);
        if !textFromFile.isEmpty {
            text = textFromFile;
        }
        Helpers.convertTextToUsers(text: text);
        
    }
    
    static func saveUserAccounts () -> Void {
        var text = "";
        for user in AllBankersAndCustomers {
            text.append(contentsOf: "\(user.username),\(user.password),\(user.type == .Banker ? "Banker": "Customer")\n") ;
        }
        FileReader.saveToFile(fileName: "Users.txt", content: text);
        
    }
    
}






