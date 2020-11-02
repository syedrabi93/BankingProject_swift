//
//  main.swift
//  BankProject
//
//  Created by Rabiyama, Syed on 10/31/20.
//  Copyright © 2020 Rabiyama, Syed. All rights reserved.
//

import Foundation

//array initialisation for the objects of type class BankAccount
var AllAccounts: [BankAccount] = [BankAccount]();

//array initialisation for the objects of type class Account
var AllBankersAndCustomers: [Account] = [Account]();

var AllBankers: [Banker] = [Banker]();

//function call to initate the bank account details to be loaded to the array of objects
BankAccount.readBankAccounts();
//function call to initate the bank login details to be loaded to the array of objects
Account.readUserAccounts();
//function call to initate the banker details to be loaded to the array of objects
Banker.readUserBankers()

//enum for exception handling types
enum ReadInt: Error {
    case InvalidNumberEntered
}

func readInt() throws ->Int{
    
    guard let val = Int(readLine()!) else {
        throw ReadInt.InvalidNumberEntered
    }
    return val;
}

while (true)
{
    do
    {
        print("""
    Enter the type of user login
    1.Banker
    2.Customer
    Press (1 or 2):
    """)
        
        let option = try readInt();
        
        if(option == 1)
        {
            do{
                let type = UserType.Banker;
                print("""
        Banker Sign In - Press 1
        Banker Sign Up - Press 2
        """);
                let option = try readInt();
                if(option == 1){
                    
                    let userAccount = Account.checkSignIn(type: type);
                    
                    if(userAccount == nil){
                        print("No BankAccount Found With Entered Credentials. Try Again");
                        continue;
                    } else {
                        print("Successfully Signed In");
                        handleBankerOptions()
                    }
                }
                if(option == 2){
                    
                    let userName = Helpers.askQuestion(ques: "Enter UserName");
                    let password = Helpers.askQuestion(ques: "Enter Password");
                    let type = UserType.Banker;
                    let user = Account.findUser(userName: userName ,type: type);
                    let exist = Banker.isBankerExist(user: userName)
                    if(user == nil && exist == true){
                        // user Doesnt exit add useraccount;
                        AllBankersAndCustomers.append(Account(username: userName, password: password, type: type));
                        continue;
                    }
                    else if exist == false{
                        print ("The user \(userName) isn't an active employee. Invalid login")
                        
                    }
                    else {
                        print("A user with username \(userName) already exists.");
                        print("Try Again");
                    }
                }
            }catch ReadInt.InvalidNumberEntered {
                print("Invalid Number Entered");
            }
            
            
        }
        if(option == 2)
        {
            do
            {
                let type = UserType.Customer;
                print("""
          Customer Sign In - Press 1
          Customer Sign Up - Press 2
        """);
                let option = try readInt()
                if(option == 1){
                    let userAccount = Account.checkSignIn(type: type);
                    if(userAccount == nil){
                        print("No BankAccount Found With Entered Credentials");
                        continue;
                    } else {
                        print("Successfully Signed In");
                        handleCustomerOptions(clientId: userAccount!.username);
                    }
                }
                if(option == 2){
                    let userName = Helpers.askQuestion(ques: "Enter Username");
                    let password = Helpers.askQuestion(ques: "Enter Password");
                    let type = UserType.Customer;
                    let user = Account.findUser(userName: userName , type: type);
                    let exist = BankAccount.isCustomerExist(user: userName)
                    if(user == nil && exist == true){
                        // user Doesnt exit add useraccount;
                        AllBankersAndCustomers.append(Account(username: userName, password: password, type: type));
                        continue;
                    }
                    else if exist == false{
                        print ("The user \(userName) doesn't have active accout. Invalid login . First create a bank account with the help of banker and then create login after successful account activation")
                        
                    }
                    else {
                        print("A user with username \(userName) already exists.");
                        print("Try Again");
                    }
                    
                }
            }catch ReadInt.InvalidNumberEntered {
                print("Invalid Number Entered");
            }
        }
    }
    catch ReadInt.InvalidNumberEntered {
        print("Invalid Number Entered");
    }
    
}



func handleBankerOptions () -> Void {
    while (true){
        do
        {
        print("""
            Select the operation you would like to do
            1.List accounts
            2.Add account
            3.Delete Acount
        """);
        print("Enter your option (1/2/3):");
            let option = try readInt();
        
        if(option == 1){
            print("|ClientID\t accountNo|\taccountType|\tClientName|\tContact")
            for account in AllAccounts {
                account.printInfoBanker()
            }
        }
        if(option == 2){
            print("If Existing Customer Press 0 otherwise 1");
            var oldAccount : BankAccount? = nil;
            let existingCustomer = Int(readLine()!) == 0;
            if(existingCustomer){
                while (true){
                    print("Enter Existing Client Id :")
                    let clientId = readLine()!;
                    let oldAccounts = BankAccount.findAccountsByClientId(clientId: clientId)
                    if(oldAccounts != nil){
                        oldAccount = oldAccounts![0];
                        break;
                    }else {
                        print("Invalid ClientID enterd \n Enter 1 to Try Again or 0 to Go Back");
                        if Int(readLine()!) == 0{
                            break;
                        }
                    }
                }
            }
            
            let clientId: String = oldAccount == nil ? Helpers.askQuestion(ques: "Enter ClientId:"): oldAccount!.clientID;
            let clientName: String = oldAccount == nil  ? Helpers.askQuestion(ques: "Enter Client Name:"): oldAccount!.clientID;
            let contact: String = oldAccount == nil ? Helpers.askQuestion(ques: "Enter Contact:"): oldAccount!.Contact;
            let accountType: String = Int(Helpers.askQuestion(ques: "Enter the BankAccount Type to be created:\n\n 1.Savings account \t 2 Current account\n")) == 1 ? "Savings" : "Current"
            let newAccount = BankAccount(clientID: clientId, accountType: accountType, ClientName: clientName, Contact: contact, accountNo: BankAccount.generateAccountNum() , currentBalance: 0.0, previousTransaction: 0.0)
            AllAccounts.append(newAccount);
            
            print("BankAccount Created SuccessFully");
            newAccount.printInfoBanker();
        }
        if(option == 3){
            
            let clientId = Helpers.askQuestion(ques: "Enter ClientId to be deleted:");
            let accountNum = Int(Helpers.askQuestion(ques: "Enter BankAccount Number to be Deleted:"));
            let accountType = Helpers.askQuestion(ques: "Enter the BankAccount Type to be deleted:");
            
            let index = AllAccounts.firstIndex(where: {$0.accountNo == accountNum && $0.clientID == clientId && $0.accountType == accountType});
            if(index != nil){
                AllAccounts.remove(at: index!);
            }else {
                print("Could Find The BankAccount With Provided Details . Try Again");
            }
            
        }
        
        Helpers.ExitIfWantsTo();
        
        }catch ReadInt.InvalidNumberEntered {
            print("Invalid Number Entered");
            
        }
        catch {
            print("Invalid Number Entered");
        }
    
    }
}



func handleCustomerOptions (clientId: String) -> Void {
    while (true){
        do{
        print("""
            Select the operation you would like to do
            1.View BankAccount
            2.Transfer Amount
            3.Deposit Amount
            4.Withdraw Amount
            5.Pay utilities
            6.Update Personal Details
        """);
        print("Enter the option between 1 to 5:");
        let option = try readInt()
        let accounts: [BankAccount] = BankAccount.findAccountsByClientId(clientId: clientId)!;
        switch option {
        case 1:
            
            
            print("Your BankAccount Details");
            print("clientID AccNo AccType    Name      Contact cur.Balance prev.Transaction")
            accounts.forEach({$0.printInfoCustomer()});
            
            break;
        case 2:
            print("Your BankAccount Details");
            print("clientID AccNo AccType     Name      Contact cur.Balance prev.Transaction")
            accounts.forEach({$0.printInfoCustomer()});
            
            let sourceAccountNum = Int(Helpers.askQuestion(ques: "Confirm the BankAccount number from which the transaction to be done (from the list shown) "))!;
            let destAccountNum = Int(Helpers.askQuestion(ques: "Enter the BankAccount number for which amount to be transfered"))!;
            let amount = Double(Helpers.askQuestion(ques: "Enter the BankAccount number for which amount to be transfered"))!;
            if(!BankAccount.handleTransfer(srcAccNum: sourceAccountNum, destAccNum: destAccountNum, amount: amount)){
                print("Transfer Failed");
            }
            
        case 3:
            print("Your BankAccount Details");
            print("clientID AccNo AccType     Name        Contact cur.Balance prev.Transaction")
            accounts.forEach({$0.printInfoCustomer()});
            let accountNum = Int(Helpers.askQuestion(ques: "Confirm the BankAccount number to be deposited\n"))!;
            
            let amount = Double(Helpers.askQuestion(ques: "Enter Amount To be Deposited"))!;
            if(BankAccount.handleDeposit(accountNum: accountNum, amount: amount)){
                print("$\(amount ) Deposited To BankAccount \(accountNum)");
            }else {
                print("Failed To Deposit Amount");
            }
        case 4:
            print("Your BankAccount Details");
            print("clientID AccNo AccType      Name       Contact cur.Balance prev.Transaction")
            accounts.forEach({$0.printInfoCustomer()});
            let accountNum = Int(Helpers.askQuestion(ques: "Confirm the BankAccount number from which you want to withdraw the amount:"))!;
            let amount = Double(Helpers.askQuestion(ques: "Enter the Amount "))!;
            
            if(BankAccount.handleWithDrawal(accountNum: accountNum, amount: amount)){
                print("$\(amount ) WithDrawn To BankAccount \(accountNum)");
            }else {
                print("Failt to WithDraw Amount");
            }
        case 5 :
            print("Your BankAccount Details");
            print("clientID AccNo AccType     Name       Contact cur.Balance prev.Transaction")
            accounts.forEach({$0.printInfoCustomer()});
            let utils = ["Mobile Recharge","Electricity Bill", "Wifi Bill", "Insurance", "Gas Bill"];
            let ubNum = Int(Helpers.askQuestion(ques: """
            Select the Utility type to make payment
            1.Mobile Recharge
            2.Electricity Bill
            3.Wifi Bill
            4.Insurance
            5.Gas Bill
            """))! - 1;
            let UtilName = utils[ubNum];
            let accountNumber = Int(Helpers.askQuestion(ques: "Confirm the BankAccount number from which the utils to be payed"))!;
            let amount = Double(Helpers.askQuestion(ques: "Enter the Amount "))!;
            
            if(BankAccount.handleWithDrawal(accountNum: accountNumber, amount: amount)){
                print("Bill Payment Success for \(UtilName)");
            }else {
                print("Payment Failed.");
            }
            
        case 6 :
            let ans = Int(Helpers.askQuestion(ques: "You can edit the Name and Contact details . Enter your choice to edit \n\n1.Name\n2.Contact \n Press 0 to Cancel And Go Back"))!;
            
            
            if(ans == 0){
                break;
            }
            if(ans == 1){
                let newName = Helpers.askQuestion(ques: "Enter the New name to be updated");
                
                for acc in accounts {
                    acc.ClientName = newName;
                }
                print("Update name succcessful")
            }
            if(ans == 2){
                let newPhone = Helpers.askQuestion(ques: "Enter the New name to be updated");
                for var acc in accounts {
                    acc.Contact = newPhone;
                }
                print("Update Phone succcessful")
            }
        default:
            Helpers.ExitIfWantsTo()
        }
        Helpers.ExitIfWantsTo()
    }catch ReadInt.InvalidNumberEntered {
        print("Invalid Number Entered");
        
    }
    catch {
        print("Invalid Number Entered");
    }
}
    
}
