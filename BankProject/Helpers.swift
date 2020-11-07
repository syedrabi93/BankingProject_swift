//
//  File.swift
//  BankProject
//
//  Created by Adarshdeep Singh on 01/11/20.
//  Copyright © 2020 Rabiyama, Syed. All rights reserved.
//

import Foundation

//Helper class contains the common methods thats used across the application to avoid redundant code
class Helpers {
    /*Function to convert the text read from the file or the preloaded text to the format     * required for the object type BankAccount by sepreating it with the delimitter ","
     * parameters : Tect to be converted
     * returns void
     */
    static func convertTextToAccounts(text: String) -> Void {
        let arr = text.split(separator: "\n");
        arr.forEach{
            let details = $0.split(separator: ",");
            AllAccounts.append(BankAccount(clientID: String(details[0]), accountType: String(details[1]), ClientName: String(details[2]), Contact: String(details[3]), accountNo: Int(String(details[4])) ?? 100000, currentBalance: (String(details[5]) as NSString).doubleValue,previousTransaction : (String(details[6]) as NSString).doubleValue))
        }
    }

    /*Function to convert the text read from the file or the preloaded text to the format     * required for the object type Account by sepreating it with the delimitter ","
     * parameters : Tect to be converted
     * returns void
     */
    static func convertTextToUsers(text: String) -> Void {
        let arr = text.split(separator: "\n");
        arr.forEach{
            let details = $0.split(separator: ",");
            AllBankersAndCustomers.append(Account(username: String(details[0]), password: String(details[1]), type: String(details[2]) == "Banker" ? .Banker : .Customer));
        }
    }
    /*Function to convert the text read from the file or the preloaded text to the format     * required for the object type Banker by sepreating it with the delimitter ","
     * parameters : Tect to be converted
     * returns void
     */
    static func convertTextToBankers(text: String) -> Void {
        let arr = text.split(separator: "\n");
        arr.forEach{
            let details = $0.split(separator: ",");
            AllBankers.append(Banker(bankerID:String(details[0]) , bankerName: String(details[1]) ))
        }
    }
    
    //When the user decides to exit from the application, this functions saves all the object values to the corresponding storage file
    static func ExitIfWantsTo () -> Void {
        print("Press 0 to exit or 1 To go Back")
        let option = Int(readLine()!)!;
        if(option == 0){
            BankAccount.saveAccounts ()
            Account.saveUserAccounts()
            Banker.saveBankerAccounts()
            exit(0)
        }
    };
    //function to get user inputs
    static func askQuestion (ques: String)-> String {
        print(ques);
        return readLine()!;
    }

}
