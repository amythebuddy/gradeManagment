//
//  main.swift
//  gradeManager
//
//  Created by StudentAM on 1/22/24.
//

import Foundation
import CSV

func readCSVFiles(data: inout [[String]]) { // inout allows changes for data
    do {
        let stream = InputStream(fileAtPath: "/Users/studentam/Desktop/grades.csv")
        data = []
        let csv = try CSVReader(stream: stream!)
        while let row = csv.next(){
            data.append(row)
        }
    } catch {
        print("An error occurred: \(error)")
        fatalError("There is an error trying to read the files. Check if the file path is correct.")
    }
}

// calculate grade of each student
func calculateGradeOfEachStudent(through data: [[String]]) -> [String : Double]{
    var studentsWithAverageGrades = [String : Double]()
    var sumOfEachStudent = 0.0
    for i in data.indices {
        for j in 1..<data[i].count{
            if let gradeOfEachAssignment = Double(data[i][j]){
                sumOfEachStudent += gradeOfEachAssignment //add all of the assigments grade
            }
        }
        let averageOfSingleStudent = sumOfEachStudent / Double((data[i].count - 1)) // divide to the amount of assignments
        studentsWithAverageGrades[data[i][0]] = averageOfSingleStudent
        sumOfEachStudent = 0.0
    }
    return studentsWithAverageGrades
}
func findStudent(byName name : String, accessThrough data: [[String]]) -> [String]? {
    let lowercaseName = name.lowercased() //turn all name to lowercase
    for student in data {
        if student.firstIndex(where: {$0.lowercased() == lowercaseName}) != nil {
            return student
        }
    }
    return nil
}
func showMainMenu(){
    var studentGrades: [[String]] = []
    var menuRunning = true
    var studentsWithAverageGrades = calculateGradeOfEachStudent(through: studentGrades)
    readCSVFiles(data: &studentGrades)
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
              + "9. Change grade of an assignment\n"
              + "10. Quit")
        
        if let userInput = readLine() {
            switch userInput{
            case "1", "2":
                print("Which student would you like to choose?")
                if let nameInput = readLine(), let studentName = findStudent(byName: nameInput, accessThrough: studentGrades) {
                    print("\(studentName[0])'s grade(s) is/are:", terminator: " ")
                    if userInput == "1" {
                        print("\(studentsWithAverageGrades[studentName[0]]!)") //get the grade of that student
                    } else {
                        showAllGradesOfAStudent(studentName)
                    }
                } else {
                    print("There is no student with that name.")
                    continue
                }
            case "3":
                showAllGradesOfAll(students: studentGrades)
            case "4":
                calculateAverageGradeOfTheClass(with: studentGrades)
            case "5":
                findAverageGradeOfAssignment(with: studentGrades)
            case "6", "7":
                if userInput == "7" {
                    let highestGrade = studentsWithAverageGrades.max{$0.value < $1.value}
                    print("\(highestGrade!.key) is the student with the highest grade: \(highestGrade!.value)")
                } else {
                    let lowestGrade = studentsWithAverageGrades.min{$0.value < $1.value}
                    print("\(lowestGrade!.key) is the student with the lowest grade: \(lowestGrade!.value)")
                }
                case "8": // filter students by grade range
                print("Enter the low range you would like to use: ")
                guard let lowNumber = readLine(), let lowGrade = Double(lowNumber) else {
                    print("Please enter a number!")
                    continue
                }
                print("Enter the high range you would like to use: ")
                guard let highNumber = readLine(), let highGrade = Double(highNumber) else {
                    print("Please enter a number!")
                    continue
                }
                if lowGrade > highGrade {
                    print("The low range is bigger than the high range. Please enter back.")
                } else {
                    //filter the grade that is higher than lowGrade and lower than highGrade
                    // return back a dictionary of students with in range grade
                    let studentsInRange = studentsWithAverageGrades.filter({$0.value > lowGrade && $0.value < highGrade})
                    for student in studentsInRange { // for each student in range, print out their name and grade
                        print("\(student.key): \(student.value)")
                    }
                }
                case "9":
                    print("What student do you want to change?")
                    guard let nameInput = readLine(), var studentName = findStudent(byName: nameInput, accessThrough: studentGrades) else {
                        print("There is no student with that name")
                        continue
                    }
                    print("Which assignent grade would you like to change (1-10):")
                    guard let number = readLine(), let assignmentNumber = Int(number), assignmentNumber > 0, assignmentNumber < 11 else {
                        print("Please enter a number from 1 to 10")
                        continue
                    }
                    print("What is the new grade of this student?")
                    guard let grade = readLine(), let newGrade = Double(grade), newGrade > 0.0 else {
                        print("Please enter a postive number.")
                        continue
                    }
                    studentName[assignmentNumber] = grade // change the assignment grade
                    if let index = studentGrades.firstIndex(where: { $0[0] == studentName[0] }) { //if spotted the student in studentGrades
                        studentGrades[index] = studentName // change the whole array of grades
                    }
                    let newGradeOfStudent = calculateGradeOfEachStudent(through: studentGrades) // recalculate the grade after changes
                    studentsWithAverageGrades = newGradeOfStudent // change the average grades
                    print("You have changed \(studentName[0])'s grades of assingment #\(assignmentNumber)")
                case "10":
                    print("Have a great rest of your day!")
                    menuRunning = false
                default:
                    print("Please enter an appropriate choice!") // if the user enter something outside from 1 to 10
            }
        }
    }
}
func showAllGradesOfAll(students: [[String]]){
    for i in students.indices{
        // terminator is to connect the second print to this line
        print("\(students[i][0]) grades are:", terminator: " ")
        // map is pulling each element out and joined with each other with comma
        let gradesString = students[i][1...].map{$0}.joined(separator: ", ")
        print(gradesString)
    }
}
func showAllGradesOfAStudent(_ student: [String]){
    //dropFirst means remove the first element without changing the original array
    let gradesString = student.dropFirst().joined(separator: ", ")
    print(gradesString)
}
func calculateAverageGradeOfTheClass(with data: [[String]]) {
    var average = 0.0
    var sumOfClass = 0.0
    var totalAssignment = 0.0
    for i in data.indices{
        for j in 1..<data[i].count{
            if let gradeOfEachAssignment = Double(data[i][j]){
                // add each assignment grade to the sum
                sumOfClass += gradeOfEachAssignment
            }
            totalAssignment += 1 // add the amount of assignment
        }
    }
    average = sumOfClass / totalAssignment
    print("The class average is: " + String(format: "%.2f", average))
}
func findAverageGradeOfAssignment(with data: [[String]]){
    print("Which assignent would you like to get the average of (1-10):")
    guard let number = readLine(), let assignmentNumber = Int(number), assignmentNumber > 0, assignmentNumber < 11 else {
        print("Please enter a number from 1 to 10")
        return
    }
    var sumOfAssignmentGrades = 0.0
    var sumOfAmountOfThatAssignment = 0.0
    for i in data.indices{
        if let gradeOfEachAssignment = Double(data[i][assignmentNumber]){ // get that assignment grade
            sumOfAssignmentGrades += gradeOfEachAssignment // add each assignment grade to the sum
            sumOfAmountOfThatAssignment += 1 // add an amount of assignment
        }
    }
    let averageOfAnAssignment = sumOfAssignmentGrades / sumOfAmountOfThatAssignment
    print("The average for assignment #\(assignmentNumber) is: " + String(format: "%.2f", averageOfAnAssignment))
}
showMainMenu()
