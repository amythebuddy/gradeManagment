//
//  main.swift
//  gradeManager
//
//  Created by StudentAM on 1/22/24.
//

import Foundation
import CSV

//MARK: variable declaration
var studentGrades: [[String]] = []
var studentsWithAverageGrades = [String : Double]()

do {
    let stream = InputStream(fileAtPath: "/Users/studentam/Desktop/grades.csv")
    
    let csv = try CSVReader(stream: stream!)
    while let row = csv.next(){
        studentGrades.append(row)
    }
} catch {
    print("There is a error trying read the files. Check if the file path is correct")
}

// calculate grade of each student
func calculateGradeOfEachStudent(){
    var sumOfEachStudent = 0.0
    var averageOfSingleStudent = 0.0
    for i in studentGrades.indices {
        for j in 1..<studentGrades[i].count{
            if let gradeOfEachAssignment = Double(studentGrades[i][j]){
                sumOfEachStudent += gradeOfEachAssignment //add all of the assigments grade
            }
        }
        averageOfSingleStudent = sumOfEachStudent / Double((studentGrades[i].count - 1)) // divide to the amount of assignments
        studentsWithAverageGrades[studentGrades[i][0]] = averageOfSingleStudent
        sumOfEachStudent = 0.0
    }
}
func findStudent(byName name : String) -> [String]? {
    let lowercaseName = name.lowercased() //turn all name to lowercase
    for student in studentGrades {
        if student.firstIndex(where: {$0.lowercased() == lowercaseName}) != nil {
            return student
        }
    }
    return nil
}
calculateGradeOfEachStudent()
func showMainMenu(){
    var menuRunning = true
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
                    if let nameInput = readLine(), let studentName = findStudent(byName: nameInput) {
                        print("\(studentName[0])'s grade(s) is/are:", terminator: " ")
                        if userInput == "1" {
                            print("\(studentsWithAverageGrades[studentName[0]]!)") //get the grade of that student
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
                case "5":
                    findAverageGradeOfAssignment()
                case "6":
                    findLowestGrade()
                case "7":
                    findHighestGrade()
                case "8":
                    filterStudentByGradeRange()
                case "9":
                    changeGradeOfAssignment()
                case "10":
                    print("Have a great rest of your day!")
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
        // map is pulling each element out and joined with each other with comma
        let gradesString = studentGrades[i][1...].map{$0}.joined(separator: ", ")
        print(gradesString)
    }
}
func showAllGradesOfAStudent(_ student: [String]){
    //dropFirst means remove the first element without changing the original array
    let gradesString = student.dropFirst().joined(separator: ", ")
    print(gradesString)
}
func calculateAverageGradeOfTheClass() {
    var average = 0.0
    var sumOfClass = 0.0
    var totalAssignment = 0.0
    for i in studentGrades.indices{
        for j in 1..<studentGrades[i].count{
            if let gradeOfEachAssignment = Double(studentGrades[i][j]){
                // add each assignment grade to the sum
                sumOfClass += gradeOfEachAssignment
            }
            totalAssignment += 1 // add the amount of assignment
        }
    }
    average = sumOfClass / totalAssignment
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
func findAverageGradeOfAssignment(){
    print("Which assignent would you like to get the average of (1-10):")
    guard let number = readLine(), let assignmentNumber = Int(number), assignmentNumber > 0, assignmentNumber < 11 else {
        print("Please enter a number from 1 to 10")
        return
    }
    var sumOfAssignmentGrades = 0.0
    var sumOfAmountOfThatAssignment = 0.0
    for i in studentGrades.indices{
        if let gradeOfEachAssignment = Double(studentGrades[i][assignmentNumber]){ // get that assignment grade
            sumOfAssignmentGrades += gradeOfEachAssignment // add each assignment grade to the sum
            sumOfAmountOfThatAssignment += 1 // add an amount of assignment
        }
    }
    let averageOfAnAssignment = sumOfAssignmentGrades / sumOfAmountOfThatAssignment
    print("The average for assignment #\(assignmentNumber) is: " + String(format: "%.2f", averageOfAnAssignment))
}
func filterStudentByGradeRange(){
    print("Enter the low range you would like to use: ")
    guard let lowNumber = readLine(), let lowGrade = Double(lowNumber) else {
        return
    }
    print("Enter the high range you would like to use: ")
    guard let highNumber = readLine(), let highGrade = Double(highNumber) else {
        return
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
}
func changeGradeOfAssignment(){
    print("What student do you want to change?")
    guard let nameInput = readLine(), var studentName = findStudent(byName: nameInput) else {
        print("There is no student with that name")
        return
    }
    print("Which assignent grade would you like to change (1-10):")
    guard let number = readLine(), let assignmentNumber = Int(number), assignmentNumber > 0, assignmentNumber < 11 else {
        print("Please enter a number from 1 to 10")
        return
    }
    print("What is the new grade of this student?")
    guard let grade = readLine(), let newGrade = Double(grade), newGrade > 0 else {
        print("Please enter a postive number.")
        return
    }
    studentName[assignmentNumber] = grade // change the assignment grade
    for i in studentGrades.indices { // for each student
        if studentGrades[i][0] == studentName[0]{ //if spotted the student in studentGrades
            studentGrades[i] = studentName // change the whole array of grades
        }
    }
    calculateGradeOfEachStudent()
    print("You have changed \(studentName[0])'s grades of assingment #\(assignmentNumber)")
}
showMainMenu()
