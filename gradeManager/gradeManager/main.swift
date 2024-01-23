//
//  main.swift
//  gradeManager
//
//  Created by StudentAM on 1/22/24.
//

import Foundation
import CSV

var menuRunning = true
var studentGrades: [[String]] = [[]]
var sum = 0.0

do {
    let stream = InputStream(fileAtPath: "/Users/studentam/Desktop/iOS practice/gradeManagment/grade.csv")
    
    let csv = try CSVReader(stream: stream!)
    
    while let row = csv.next(){
        studentGrades.append(row)
    }
    
} catch {
    print("There is a error trying read the files. Check if the file path is correct")
}

func showMainMenu(){
    while menuRunning {
        print("Welcome to the Grade Manager!\n"
              + "What would you like to do? (Enter the number):\n"
              + "1. Display grade of a single student \n"
              + "2. Display all grades for a student\n"
              + "3. Display all grades of ALL students \n"
              + "4. Find the average grade of an assignment\n"
              + "5. Find the average grade of the class \n"
              + "6. Find the lowest grade in the class \n"
              + "7. Find the highest grade of the class\n"
              + "8. Filter students by grade range\n"
              + "9. Quit")
    }
    if let userInput = readLine() {
        switch userInput{
            case "1", "2":
                print("Which student would you like to choose?")
            case "4":
                for i in studentGrades.indices{
                    for j in 1..<studentGrades[i].count{
                       sum += Double(studentGrades[i][j])!
                        
                        
                    }
                }
                print("The class average is:")
            case "9":
                menuRunning = false
            default:
                print("Please enter an appropriate choice!")
        }
    }
}
