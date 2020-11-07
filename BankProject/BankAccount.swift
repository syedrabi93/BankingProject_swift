//
//  Account.swift
//  BankProject
//
//  Created by Adarshdeep Singh on 01/11/20.
//  Copyright © 2020 Rabiyama, Syed. All rights reserved.
//

import Foundation


//Class of the actual bank accounts containing all the cus
class BankAccount {
    var clientID: String;
    var accountType: String;
    var ClientName: String;
    var Contact: String;
    var accountNo: Int;
    var currentBalance: Double;
    var previousTransaction: Double ;
    
//Initialization
    init (clientID: String , accountType: String , ClientName: String , Contact: String , accountNo: Int ,currentBalance: Double , previousTransaction: Double  ){
        self.clientID = clientID
        self.accountType = accountType
        self.ClientName = ClientName
        self.Contact = Contact
        self.accountNo = accountNo
        self.currentBalance = currentBalance
        self.previousTransaction = previousTransaction
    }
    //function that returns true if the login is successful
    func login (userName: String, password: String) -> Bool {
        
        return true;
    }
    //funtion to print the details for banker request(just the basic banker details)
    func printInfoBanker() -> Void {
        print("\(clientID)\t\(accountNo)\t\(accountType)\t\(ClientName)\t\(Contact)")
    }
    
    //function that prints the account balance and details for the customer
    func printInfoCustomer() -> Void {
        print("\(clientID)\t\(accountNo)\t\(accountType)\t\(ClientName)\t\(Contact)\t\(currentBalance)\t\(previousTransaction)")
    }
    
    /*function to withdrraw ammount from a particular account number. updates the balance
    * after withdrawal and the previous transaction with the amont withdrawed for the track
    * parameters : account number and the amount
    * returns true on on successful withdrawal
    */
    static func handleWithDrawal(accountNum: Int, amount: Double)-> Bool{
        var accountin: BankAccount? = nil;
        for account in AllAccounts {
            if(account.accountNo == accountNum){
                accountin = account;
                break;
            }
        }
        if(accountin == nil){
            print("Could Find Account With Account Num \(accountNum)")
            return false;
        }
        
        //checks is there is enough amount to do withdrawal
        if (accountin!.currentBalance < amount){
            print("Source Account Doesn't have balance close to $\(amount)")
            return false
        }
        
        //updates the account balance
        accountin?.currentBalance -= amount;
        accountin?.previousTransaction = -amount
        
        return true;
    }
    
    //Function to auto generate new account number on new account creation
    //returns the generated account number
    static func generateAccountNum() -> Int{
          
           var randNum = 0;
           while true {
               let generatedNum = Int(drand48() * 10000 + 10000);
               let index = AllAccounts.firstIndex(where: {$0.accountNo == generatedNum});
               if index == nil {
                   randNum = generatedNum;
                   break;
                   
               }
           }
           return randNum;
       }
    
    /*function allows the user to deposit amount. updates the balance
    * after withdrawal and the previous transaction with the amount deposited for the track
    */
    static func handleDeposit(accountNum: Int, amount: Double)-> Bool{
        var accountin: BankAccount? = nil;
        for account in AllAccounts {
            if(account.accountNo == accountNum){
                accountin = account;
                break;
            }
        }
        
        if(accountin == nil){
            print("Could Find Account With Account Num \(accountNum)")
            return false;
        }
        
        //updates the account balance
        accountin?.currentBalance += amount;
        accountin?.previousTransaction = +amount
        
        return true;
    }
    
    //function to automatically find the account number from the logged in customerid
    static func findAccountsByClientId (clientId: String)-> [BankAccount]? {
          let accounts = AllAccounts.filter({(item) -> Bool in
              item.clientID == clientId;
          })
          if(accounts.isEmpty){
              return nil;
          }
          return accounts;
      }
    
    /* Function to make transactions between account within the bank. updates both the source
     * and destination account balance with the transacted amount accordingly
     * parameters: source account numbner, destination account number , amount to be transfered
     * returns true on successful completion of transaction
     */
    static func handleTransfer(srcAccNum: Int, destAccNum: Int, amount: Double) -> Bool {
        // find Source Account
        var srcAccount: BankAccount? = nil
        for account in AllAccounts {
            if(account.accountNo == srcAccNum){
                srcAccount = account;
                break;
            }
        }
        if srcAccount == nil {
            print("Account with account number \(srcAccNum) doesnt exist")
            return false
        }
        var destAccount: BankAccount? = nil;
        for account in AllAccounts {
               if(account.accountNo == destAccNum){
                   destAccount = account
                   break
               }
           }
        if destAccount == nil {
            print("Account with account number \(destAccNum) doesnt exist")
            return false;
        }
        
        if(srcAccount!.currentBalance >= (amount)){
            srcAccount!.currentBalance -= amount;
            srcAccount?.previousTransaction = -amount;
        }else {
            print("Source Account Doesn't have balance close to $\(amount)")
            return false
        }
        destAccount?.currentBalance += amount
        destAccount?.previousTransaction = +amount
        print("Amount Transferred from \(srcAccNum) to \(destAccNum)")
        return true
    }
    
    /* function to preload the customer details if the file is not empty
     * if not load the customer login data from from here (testing purpose)
     */
    static func readBankAccounts ()-> Void {
        let file = "AccountDetails.txt" //this is the file. we will write to and read from it
        
        var text = """
        Syed,Savings,SyedRabiyama,9789547607,100001,10000,100
        Syed,Current,SyedRabiyama,9789547607,100002,1000,1000
        Adarsh,Savings,Adharshdeep,9876543210,100003,5000,1000
        """ //just a text
        let textFromFile = FileReader.readFromFile(fileName: file);
        if !textFromFile.isEmpty {
            text = textFromFile;
        }
        Helpers.convertTextToAccounts(text: text);
    }
    
    //Function to finally update the file with the data while leaving the application
    //loads the data from objects to the file for permanent storage

    static func saveAccounts ()-> Void {
        var text = "";
        for account in AllAccounts {
            text.append(contentsOf: "\(account.clientID),\(account.accountType),\(account.ClientName),\(account.Contact),\(account.accountNo),\(account.currentBalance),\(account.previousTransaction)\n") ;
        }
        
        FileReader.saveToFile(fileName: "AccountDetails.txt", content: text);
    }
    
    //checks if the logged in customer is an active account holder
    static func isCustomerExist(user : String)-> Bool
    {
        if (AllAccounts.firstIndex(where: {$0.clientID == user}) != nil) == true {
            return true
        }
        return false
    }

}


