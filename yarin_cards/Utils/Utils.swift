//
//  Utils.swift
//  yarin_cards
//
//  Created by Udi Levy on 17/07/2024.
//

import Foundation
import UIKit


class Utils {
    static func trim(from string: String) -> String {
        return string.trimmingCharacters(in: .whitespaces)
    }
    
    static func getFileNames() -> [String]? {
        let fileManager = FileManager.default
        
        guard let resourcePath = Bundle.main.resourcePath else {
            return nil
        }
        
        do {
            // Get the contents of the resource path
            let contents = try fileManager.contentsOfDirectory(atPath: resourcePath)
            //              print("Contents of the resource path:")
            //              for item in contents {
            //                  print(item)
            //              }
            let pngFiles = contents.filter { $0.hasSuffix(".png") }
            return pngFiles
        } catch {
            print("Error reading contents of resource path: \(error.localizedDescription)")
        }
        
        return nil;
    }

}
