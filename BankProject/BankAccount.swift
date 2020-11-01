//
//  Account.swift
//  BankProject
//
//  Created by Adarshdeep Singh on 01/11/20.
//  Copyright © 2020 Rabiyama, Syed. All rights reserved.
//

import Foundation



class BankAccount {
    var clientID: String;
    var accountType: String;
    var ClientName: String;
    var Contact: String;
    var accountNo: Int;
    var currentBalance: Double;
    var previousTransaction: Double ;
    

    init (clientID: String , accountType: String , ClientName: String , Contact: String , accountNo: Int ,currentBalance: Double , previousTransaction: Double  ){
        self.clientID = clientID
        self.accountType = accountType
        self.ClientName = ClientName
        self.Contact = Contact
        self.accountNo = accountNo
        self.currentBalance = currentBalance
        self.previousTransaction = previousTransaction
    }
    
    func login (userName: String, password: String) -> Bool {
        
        return true;
    }
    func printInfoBanker() -> Void {
        print("\(clientID)\t\(accountNo)\t\(accountType)\t\(ClientName)\t\(Contact)")
    }
    func printInfoCustomer() -> Void {
        print("\(clientID)\t\(accountNo)\t\(accountType)\t\(ClientName)\t\(Contact)\t\(currentBalance)\t\(previousTransaction))")
    }
    
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
        accountin?.currentBalance -= amount;
        
        return true;
    }
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
        accountin?.currentBalance += amount;
        
        return true;
    }
    static func findAccountsByClientId (clientId: String)-> [BankAccount]? {
          let accounts = AllAccounts.filter({(item) -> Bool in
              item.clientID == clientId;
          })
          if(accounts.isEmpty){
              return nil;
          }
          return accounts;
      }
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
    
    static func saveAccounts ()-> Void {
        var text = "";
        for account in AllAccounts {
            text.append(contentsOf: "\(account.clientID),\(account.accountType),\(account.ClientName),\(account.ClientName),\(account.Contact),\(account.accountType),\(account.currentBalance)\n") ;
        }
        
        FileReader.saveToFile(fileName: "AccountDetails.txt", content: text);
    }

}


