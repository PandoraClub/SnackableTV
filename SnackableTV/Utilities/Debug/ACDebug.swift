//
//  ACDebug.swift
//  <?>App
//
//  Created by Austin Chen on 2016-11-15.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation

func log(error: String = "",
         function: String = #function,
         file: String = #file,
         line: Int = #line)
{
    let error = "Error: \"\(error)\""
    log(message: error)
}

func log(message: String = "",
         function: String = #function,
         file: String = #file,
         line: Int = #line)
{
    let f = file.components(separatedBy: "/").last ?? ""
    print("ACLog: \"\(message)\" - (File: \(f), Function: \(function), Line: \(line))")
}
