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
var studentsWithAverageGrades = [String : Double]()
var sumOfEachStudent = 0.0
var averageOfSingleStudent = 0.0

do {
    let stream = InputStream(fileAtPath: "/Users/nguyenhuyen/Desktop/grades.csv")
    
    let csv = try CSVReader(stream: stream!)
    
    while let row = csv.next(){
        studentGrades.append(row)
    }
} catch {
    print("There is a error trying read the files. Check if the file path is correct")
}
//MARK: average grade of each student
// calculate grade of each student
for i in studentGrades.indices {
    for j in 1..<studentGrades[i].count{
        if let gradeOfEachAssignment = Double(studentGrades[i][j]){
            sumOfEachStudent += gradeOfEachAssignment //add all of the assigments
        }
    }
    averageOfSingleStudent = sumOfEachStudent / 10 // divide to the amount of assignment
    studentsWithAverageGrades[studentGrades[i][0]] = averageOfSingleStudent
    sumOfEachStudent = 0.0
}
print(studentsWithAverageGrades)
func findStudent(byName name : String) -> [String]? {
    let lowercaseName = name.lowercased() //turn all name to lowercase
    for student in studentGrades {
        if let foundedStudent = student.firstIndex(where: {$0.lowercased() == lowercaseName}) {
            return student
        }
    }
    return nil
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
                    if let nameInput = readLine(), let studentName = findStudent(byName: nameInput) {
                        print("\(studentName[0])'s grades is/are:", terminator: " ")
                        if userInput == "1" {
                            print("\(studentsWithAverageGrades[studentName[0]]!)")
                        } else {
                            showAllGradesOfAStudent(studentName)
                        }
                    } else {
                            print("There is no student with that name.")
                    }
                case "3":
                    showAllGradesOfAllStudents()
                case "4":
                    calculateAverageGradeOfTheClass()
                case "6":
                    findLowestGrade()
                case "7":
                    findHighestGrade()
                case "9":
                    menuRunning = false
                    print("Have a great rest of your day!")
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
func showAllGradesOfAStudent(_ student: [String]){
    //dropFirst means remove the first element without changing the original array
    let gradesString = student.dropFirst().joined(separator: ", ")
    print(gradesString)
}
func calculateAverageGradeOfTheClass() {
    for i in studentGrades.indices{
        for j in 1..<studentGrades[i].count{
            if let gradeOfEachAssignment = Double(studentGrades[i][j]){
                sumOfClass += gradeOfEachAssignment
            }
            sumToCalculateAverage += 1
        }
    }
    average = sumOfClass / sumToCalculateAverage
    print("The class average is: " + String(format: "%.2f", average))
}
func findHighestGrade(){
    let highestGrade = studentsWithAverageGrades.max{$0.value < $1.value}
    print("\(highestGrade!.key) is the student with the highest grade: \(highestGrade!.value)")
}
func findLowestGrade(){
    let lowestGrade = studentsWithAverageGrades.min{$0.value < $1.value}
    print("\(lowestGrade!.key) is the student with the lowest grade: \(lowestGrade!.value)")
}
showMainMenu()
