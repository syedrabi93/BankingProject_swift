//
//  File.swift
//  BankProject
//
//  Created by Adarshdeep Singh on 01/11/20.
//  Copyright © 2020 Rabiyama, Syed. All rights reserved.
//

import Foundation


class Helpers {
    static func convertTextToAccounts(text: String) -> Void {
        let arr = text.split(separator: "\n");
        arr.forEach{
            let details = $0.split(separator: ",");
            AllAccounts.append(BankAccount(clientID: String(details[0]), accountType: String(details[1]), ClientName: String(details[2]), Contact: String(details[3]), accountNo: Int(String(details[4])) ?? 100000, currentBalance: (String(details[5]) as NSString).doubleValue,previousTransaction : (String(details[6]) as NSString).doubleValue))
        }
    }


    static func convertTextToUsers(text: String) -> Void {
        let arr = text.split(separator: "\n");
        arr.forEach{
            let details = $0.split(separator: ",");
            AllBankersAndCustomers.append(Account(username: String(details[0]), password: String(details[1]), type: String(details[2]) == "Banker" ? .Banker : .Customer));
        }
    }

    static func ExitIfWantsTo () -> Void {
        print("Press 0 to exit or 1 To go Back")
        let option = Int(readLine()!)!;
        if(option == 0){
            BankAccount.saveAccounts ()
            Account.saveUserAccounts()
            exit(0)
        }
    };

    static func askQuestion (ques: String)-> String {
        print(ques);
        return readLine()!;
    }

}
