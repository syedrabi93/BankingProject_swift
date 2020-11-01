//
//  main.swift
//  BankProject
//
//  Created by Rabiyama, Syed on 10/31/20.
//  Copyright © 2020 Rabiyama, Syed. All rights reserved.
//

import Foundation

struct Account {
    var clientID: String;
    var accountType: String;
    var ClientName: String;
    var Contact: String;
    var accountNo: Int;
    var currentBalance: Double;
    var previousTransaction: Double? = 0;
    func login (userName: String, password: String) -> Bool {
        return true;
    }
    func printInfo() -> Void {
        print("\(clientID)\t\(accountNo)\t\(accountType)\t\(ClientName)\t\(Contact)")
    }
}

enum UserType {
    case Banker
    case Customer
}
struct User {
    var username: String;
    var password: String;
    var type: UserType;
}

var AllAccounts: [Account] = [Account]();



var AllUsers: [User] = [User]();


func saveToFile (fileName:String, content: String)-> Void {
    

    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

        let fileURL = dir.appendingPathComponent(fileName);
        
        //writing
        do {
            print(fileURL);
            try content.write(to: fileURL, atomically: false, encoding: .utf8)
            
        }
        catch {
            print("Couldn't Write Data to File");
        }
       
    }
}

func readFromFile (fileName: String) -> String {
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

           let fileURL = dir.appendingPathComponent(fileName);
    //reading
           do {
               let text2 = try String(contentsOf:fileURL , encoding: .utf8)
            return text2;
               
           }
           catch {
            print("SomeThing Went Wront");
        }
    }
    return "";
}

func convertTextToUsers(text: String) -> Void {
    let arr = text.split(separator: "\n");
    arr.forEach{
        let details = $0.split(separator: ",");
        AllUsers.append(User(username: String(details[0]), password: String(details[1]), type: String(details[2]) == "Banker" ? .Banker : .Customer));
    }
}

func saveUsers () -> Void {
    var text = "";
    for user in AllUsers {
        text.append(contentsOf: "\(user.username),\(user.password),\(user.type == .Banker ? "Banker": "Customer")\n") ;
    }
    saveToFile(fileName: "Users.txt", content: text);
    
}

func convertTextToAccounts(text: String) -> Void {
    let arr = text.split(separator: "\n");
    arr.forEach{
        let details = $0.split(separator: ",");
        AllAccounts.append(Account(clientID: String(details[0]), accountType: String(details[1]), ClientName: String(details[2]), Contact: String(details[3]), accountNo: Int(String(details[4])) ?? 100000, currentBalance: (String(details[5]) as NSString).doubleValue))
    }
}
func saveAccounts ()-> Void {
    var text = "";
    for account in AllAccounts {
        text.append(contentsOf: "\(account.clientID),\(account.accountType),\(account.ClientName),\(account.ClientName),\(account.Contact),\(account.accountType),\(account.currentBalance)\n") ;
    }
    
    saveToFile(fileName: "AccountDetails.txt", content: text);
}



func readUsers () -> Void {
    let fileName = "Users.txt";
    var text = """
    Syed,test1,Customer
    Adarsh,test2,Customer
    Kaur,test3,Banker
    Wajeeh,test4,Banker
    """;
    let textFromFile = readFromFile(fileName: fileName);
    if !textFromFile.isEmpty {
        text = textFromFile;
    }
    convertTextToUsers(text: text);
    
}

func readAccounts ()-> Void {
    let file = "AccountDetails.txt" //this is the file. we will write to and read from it
    
    var text = """
    Syed,Savings,SyedRabiyama,9789547607,100001,10000,100
    Syed,Current,SyedRabiyama,9789547607,100002,1000,1000
    Adarsh,Savings,Adharshdeep,9876543210,100003,5000,1000
    """ //just a text
    let textFromFile = readFromFile(fileName: file);
    if !textFromFile.isEmpty {
        text = textFromFile;
    }
    convertTextToAccounts(text: text);
}

readAccounts();
readUsers();


func checkSignIn (type: UserType) -> User? {
    print("Enter Username:");
    let username = readLine()!;
    print("Enter Password");
    let password = readLine()!;
    var currentUser: User? = nil;
    for user in AllUsers {
        if user.password == password && user.username == username && user.type == type {
            currentUser = user;
            break;
        }
    }
    return currentUser;
}


func ExitIfWantsTo () -> Void {
    print("Press 0 to exit or 1 To go Back")
    let option = Int(readLine()!)!;
    if(option == 0){
        exit(0)
    }
};

func generateAccountNum() -> Int{
   
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

func askQuestion (ques: String)-> String {
    print(ques);
    return readLine()!;
}

func findAccountsByClientId (clientId: String)-> [Account]? {
    let accounts = AllAccounts.filter({(item) -> Bool in
        item.clientID == clientId;
    })
    if(accounts.isEmpty){
        return nil;
    }
    return accounts;
}

func handleBankerOptions () -> Void {
    while (true){
         print("""
            Select the operation you would like to do
            1.List accounts
            2.Add account
            3.Delete Acount
        """);
            print("Enter your option (1/2/3):");
             let option = Int(readLine()!)!;
        
        if(option == 1){
            print("|ClientID\t accountNo|\taccountType|\tClientName|\tContact")
            for account in AllAccounts {
                account.printInfo()
            }
        }
        if(option == 2){
            print("If Existing Customer Press 0 otherwise 1");
            var oldAccount : Account? = nil;
            let existingCustomer = Int(readLine()!)! == 0;
            if(existingCustomer){
                while (true){
                    print("Enter Existing Client Id :")
                    let clientId = readLine()!;
                    let oldAccounts = findAccountsByClientId(clientId: clientId)
                    if(oldAccounts != nil){
                        oldAccount = oldAccounts![0];
                        break;
                    }else {
                        print("Invalid ClientID enterd \n Enter 1 to Try Again or 0 to Go Back");
                        if Int(readLine()!)! == 0{
                            break;
                        }
                    }
                }
            }
           
            let clientId: String = oldAccount == nil ? askQuestion(ques: "Enter ClientId:"): oldAccount!.clientID;
            let clientName: String = oldAccount == nil  ? askQuestion(ques: "Enter Client Name:"): oldAccount!.clientID;
            let contact: String = oldAccount == nil ? askQuestion(ques: "Enter Contact:"): oldAccount!.Contact;
            let accountType: String = Int(askQuestion(ques: "Enter the Account Type to be created:\n\n 1.Savings account \t 2 Current account\n")) == 1 ? "Savings" : "Current";
            let newAccount = Account(clientID: clientId, accountType: accountType, ClientName: clientName, Contact: contact, accountNo: generateAccountNum() , currentBalance: 0.0);
            AllAccounts.append(newAccount);
            
            print("Account Created SuccessFully");
            newAccount.printInfo();
        }
        if(option == 3){
            
            let clientId = askQuestion(ques: "Enter ClientId to be deleted:");
            let accountNum = Int(askQuestion(ques: "Enter Account Number to be Deleted:"));
            let accountType = askQuestion(ques: "Enter the Account Type to be deleted:");
            
            let index = AllAccounts.firstIndex(where: {$0.accountNo == accountNum && $0.clientID == clientId && $0.accountType == accountType});
            if(index != nil){
                AllAccounts.remove(at: index!);
            }else {
                print("Could Find The Account With Provided Details . Try Again");
            }
            
        }
        
        ExitIfWantsTo();
    }
        
   
}

func handleTransfer(srcAccNum: Int, destAccNum: Int, amount: Double) -> Bool {
    // find Source Account
    var srcAccount: Account? = nil;
    for account in AllAccounts {
        if(account.accountNo == srcAccNum){
            srcAccount = account;
            break;
        }
    }
    if srcAccount == nil {
        print("Account with account number \(srcAccNum) doesnt exist");
        return false;
    }
    var destAccount: Account? = nil;
    for account in AllAccounts {
           if(account.accountNo == destAccNum){
               destAccount = account;
               break;
           }
       }
    if destAccount == nil {
        print("Account with account number \(destAccNum) doesnt exist");
        return false;
    }
    
    if(srcAccount!.currentBalance >= (amount)){
        srcAccount!.currentBalance -= amount;
        srcAccount?.previousTransaction = amount;
    }else {
        print("Source Account Doesn't have balance close to $\(amount)");
        return false;
    }
    destAccount?.currentBalance += amount;
    print("Amount Transferred from \(srcAccNum) to \(destAccNum)");
    return true;
}

func handleDeposit(accountNum: Int, amount: Double)-> Bool{
    var accountin: Account? = nil;
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
func handleWithDrawal(accountNum: Int, amount: Double)-> Bool{
    var accountin: Account? = nil;
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


func handleCustomerOptions (clientId: String) -> Void {
    while (true){
         print("""
            Select the operation you would like to do
            1.View Account
            2.Transfer Amount
            3.Deposit Amount
            4.Withdraw Amount
            5.Pay utilities
            6.Update Personal Details
        """);
            print("Enter the option between 1 to 5:");
             let option = Int(readLine()!)!;
        let accounts: [Account] = findAccountsByClientId(clientId: clientId)!;
        switch option {
         case 1:
            
            
            print("Your Account Details");
            accounts.forEach({$0.printInfo()});
            break;
        case 2:
            print("Your Account Details");
            accounts.forEach({$0.printInfo()});
            
         let sourceAccountNum = Int(askQuestion(ques: "Confirm the Account number from which the transaction to be done (from the list shown) "))!;
       let destAccountNum = Int(askQuestion(ques: "Enter the Account number for which amount to be transfered"))!;
        let amount = Double(askQuestion(ques: "Enter the Account number for which amount to be transfered"))!;
            if(!handleTransfer(srcAccNum: sourceAccountNum, destAccNum: destAccountNum, amount: amount)){
                print("Transfer Failed");
            }
                    
        case 3:
            print("Your Account Details");
            accounts.forEach({$0.printInfo()});
            let accountNum = Int(askQuestion(ques: "Confirm the Account number to be deposited\n"))!;
            
            let amount = Double(askQuestion(ques: "Enter Amount To be Deposited"))!;
            if(handleDeposit(accountNum: accountNum, amount: amount)){
                print("$\(amount ) Deposited To Account \(accountNum)");
            }else {
                print("Failed To Deposit Amount");
            }
        case 4:
            print("Your Account Details");
                       accounts.forEach({$0.printInfo()});
            let accountNum = Int(askQuestion(ques: "Confirm the Account number from which you want to withdraw the amount:"))!;
            let amount = Double(askQuestion(ques: "Enter the Amount "))!;
            if(handleWithDrawal(accountNum: accountNum, amount: amount)){
                 print("$\(amount ) WithDrawn To Account \(accountNum)");
            }else {
                print("Failt to WithDraw Amount");
            }
        case 5 :
            print("Your Account Details");
            accounts.forEach({$0.printInfo()});
            let utils = ["Mobile Recharge","Electricity Bill", "Wifi Bill", "Insurance", "Gas Bill"];
            let ubNum = Int(askQuestion(ques: """
            Select the Utility type to make payment
            1.Mobile Recharge
            2.Electricity Bill
            3.Wifi Bill
            4.Insurance
            5.Gas Bill
            """))! - 1;
            let UtilName = utils[ubNum];
            let accountNumber = Int(askQuestion(ques: "Confirm the Account number from which the utils to be payed"))!;
            let amount = Double(askQuestion(ques: "Enter the Amount "))!;
            
            if(handleWithDrawal(accountNum: accountNumber, amount: amount)){
                print("Bill Payment Success for \(UtilName)");
            }else {
                print("Payment Failed.");
            }
            
        case 6 :
            let ans = Int(askQuestion(ques: "You can edit the Name and Contact details . Enter your choice to edit \n\n1.Name\n2.Contact \n Press 0 to Cancel And Go Back"))!;
      
            
            if(ans == 0){
                break;
            }
            if(ans == 1){
                let newName = askQuestion(ques: "Enter the New name to be updated");
               
                for var acc in accounts {
                    acc.ClientName = newName;
                }
                print("Update name succcessful")
            }
            if(ans == 2){
                 let newPhone = askQuestion(ques: "Enter the New name to be updated");
                for var acc in accounts {
                   acc.Contact = newPhone;
               }
                print("Update Phone succcessful")
            }
        default:
            ExitIfWantsTo()
        }
        ExitIfWantsTo()
    }
    
    
}


func findUser(userName: String) -> User? {
    let index = AllUsers.firstIndex(where: {$0.username == userName});
    if(index == nil){
        return nil;
    }else {
        return AllUsers[index!];
    }
}


while (true){
    
    
    
    print("""
    Enter the type of user login
    1.Banker
    2.Customer
    Press (1 or 2):
    """)
    
    let option = Int(readLine()!)!;
    
    if(option == 1){
        let type = UserType.Banker;
        print("""
        Banker Sign In - Press 1
        Banker Sign Up - Press 2
        """);
        let option = Int(readLine()!)!;
        if(option == 1){
    
            let userAccount = checkSignIn(type: type);
            
            if(userAccount == nil){
                print("No Account Found With Entered Credentials. Try Again");
                continue;
            } else {
                print("Successfully Signed In");
                handleBankerOptions()
            }
        }
        if(option == 2){
          
            let userName = askQuestion(ques: "Enter UserName");
            let password = askQuestion(ques: "Enter Password");
            let type = UserType.Banker;
            let user = findUser(userName: userName);
            if(user == nil){
                // user Doesnt exit add useraccount;
                AllUsers.append(User(username: userName, password: password, type: type));
                continue;
            }else {
                print("A user with username \(userName) already exists.");
                print("Try Again");
            }
            
        }
        
    
        
    }
    if(option == 2){
        let type = UserType.Customer;
        print("""
          Customer Sign In - Press 1
          Customer Sign Up - Press 2
        """);
         let option = Int(readLine()!)!;
        if(option == 1){
             let userAccount = checkSignIn(type: type);
            if(userAccount == nil){
               print("No Account Found With Entered Credentials");
               continue;
            } else {
                print("Successfully Signed In");
                handleCustomerOptions(clientId: userAccount!.username);
            }
            
        }
        if(option == 2){
          
            let userName = askQuestion(ques: "Enter Username");
            let password = askQuestion(ques: "Enter Password");
            let type = UserType.Customer;
            let user = findUser(userName: userName);
            if(user == nil){
                // user Doesnt exit add useraccount;
                AllUsers.append(User(username: userName, password: password, type: type));
                continue;
            }else {
                print("A user with username \(userName) already exists.");
                print("Try Again");
            }
            
        }
        
    }
}

    
    
