//
//  User.swift
//  BankProject
//
//  Created by Adarshdeep Singh on 01/11/20.
//  Copyright © 2020 Rabiyama, Syed. All rights reserved.
//

import Foundation;

//enum to maintain the user type
enum UserType {
    case Banker
    case Customer
}

//class for login and maintain accounts
class Account {
    
    var username: String;
    var password: String;
    var type: UserType; // takes the type from the usertype enum
    
    //initialisation
    init(username: String, password: String, type: UserType){
        self.username = username;
        self.password = password;
        self.type = type;
    }
    
    /* function that perfroms the user validation with the given username and type
    *  parametes : username and the user type
    *  returns void
    */
    static func findUser(userName: String , type: UserType) -> Account? {
        let index = AllBankersAndCustomers.firstIndex(where: {$0.username == userName && $0.type == type});
        if(index == nil){
            return nil;
        }else {
            if checkUser(userName: userName , type: type) == true {
                    return AllBankersAndCustomers[index!];
                }
                else
                {
                    print ("The logged in user doesnt have active account available")
                    return nil;
                }
            }
        return nil;
    }
    
    /* Function to check if the given user is an existing user and returns true
     * parametes : username and the user type
     * returns : boolean
     */
    static func checkUser(userName: String , type: UserType) -> Bool
    {
        if type == UserType.Customer {
            if BankAccount.isCustomerExist(user: userName) == true{
                return true
            }
        }
        if type == UserType.Banker{
            if Banker.isBankerExist(user: userName) == true{
                return true
            }
        }
        return false
    }
    
    
    /* Function to validate the sign in for the given username and password
     * gets the user name and passwork on run time and validates if its a valid login
     * parameters: USertype
     * returns void
     */
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
    
    /* function to preload the user details if the file is not empty
     * if not load the customer login data from from here (testing purpose)
     */
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
    
    //Function to finally update the file with the data while leaving the application
    //loads the data from objects to the file for permanent storage
    
    static func saveUserAccounts () -> Void {
        var text = "";
        for user in AllBankersAndCustomers {
            text.append(contentsOf: "\(user.username),\(user.password),\(user.type == .Banker ? "Banker": "Customer")\n") ;
        }
        FileReader.saveToFile(fileName: "Users.txt", content: text);
        
    }
    
}






