//
//  main.swift
//  gradeManager
//
//  Created by StudentAM on 1/22/24.
//

import Foundation
import CSV

//variable declaration
var menuRunning = true
var studentGrades: [[String]] = []
var sumOfClass = 0.0
var sumToCalculateAverage = 0.0
var average = 0.0
var studentsWithGrades: [String : Double] = [:]

do {
    let stream = InputStream(fileAtPath: "/Users/studentam/Desktop/grades.csv")
    
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
              + "1. Display average grade of a single student \n"
              + "2. Display all grades for a student\n"
              + "3. Display all grades of ALL students \n"
              + "4. Find the average grade of the class \n"
              + "5. Find the average grade of an assignment \n"
              + "6. Find the lowest grade in the class \n"
              + "7. Find the highest grade of the class\n"
              + "8. Filter students by grade range\n"
              + "9. Quit")
        
        if let userInput = readLine() {
            switch userInput{
                case "1", "2":
                    print("Which student would you like to choose?")
                case "3":
                    showAllGradesOfAllStudents()
                case "4":
                    for i in studentGrades.indices{
                        for j in 1..<studentGrades[i].count{
                            sumOfClass += Double(studentGrades[i][j])!
                            sumToCalculateAverage += 1
                        }
                    }
                    average = sumOfClass / sumToCalculateAverage
                print("The class average is: " + String(format: "%.2f", average))
                case "9":
                    menuRunning = false
                default:
                    print("Please enter an appropriate choice!")
            }
        }
    }
}
func showAllGradesOfAllStudents(){
    for i in studentGrades.indices{
        // terminator is to connect the second print to this line
        print("\(studentGrades[i][0]) grades are:", terminator: " ")
        // connect the grades element with the comma
        let gradesString = studentGrades[i][1...].map{$0}.joined(separator: ", ") // map is pulling each element out and joined with each other with comma
        print(gradesString)
    }
}
func calculateGradeOfEachStudent(){
    for i in studentGrades.indices{
        studentsWithGrades[studentGrades[i][0]]
    }
}
showMainMenu()
