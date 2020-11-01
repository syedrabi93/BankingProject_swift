//
//  FileReader.swift
//  BankProject
//
//  Created by Adarshdeep Singh on 01/11/20.
//  Copyright © 2020 Rabiyama, Syed. All rights reserved.
//

import Foundation

class FileReader {
    
    static func saveToFile (fileName:String, content: String)-> Void {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(fileName);
            
            //writing
            do {
                print(fileURL);
                try content.write(to: fileURL, atomically: false, encoding: .utf8);
            }
            catch {
                print("Couldn't Write Data to File");
            }
        }
    }

    static func readFromFile (fileName: String) -> String {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first  {

            let fileURL = dir.appendingPathComponent(fileName);
            //reading
               do {
                   let text2 = try String(contentsOf:fileURL , encoding: .utf8)
                return text2;
                   
               }
               catch  {
                print("SomeThing Went Wrong");
            }
        }
        return "";
    }
}
