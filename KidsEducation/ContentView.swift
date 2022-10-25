//
//  ContentView.swift
//  KidsEducation
//
//  Created by Aleksey Nosik on 12.10.2022.
//

import SwiftUI

struct ContentView: View {

    @State private var maxQuestions = 5
    @State private var userAnswer = 0
    @State private var currentScore = 0
    @State private var currentTable = 5

    @State private var answerIsCorrect = false
    @State private var buttonIsDisabled = false
    @State private var disableLabel = false
    @State private var disableTextField = false
    
    @State private var numForArr = Int.random(in: 0...9)
    @State private var correctAnswer = 0
    @State private var markerQuestions = 1
    @State private var theEndGame = false
    @FocusState private var amountFocus: Bool
    
    let amountQuestions = [5, 10, 20]
    let table = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    let arrayOfAnimals = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "monkey", "moose"].shuffled()
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Form {
                        Section("Settings") {
                            VStack{
                                Text("Amount questions")
                                    .font(.headline)
                                
                                Picker("", selection: $maxQuestions) {
                                    ForEach(amountQuestions, id: \.self) {
                                        Text($0, format: .number)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            
                            
                            VStack {
                                Text("Multiplication table by:")
                                    .font(.headline)
                                
                                Picker("", selection: $currentTable) {
                                    ForEach(table, id: \.self) {
                                        Text($0, format: .number)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                        
                        Section("Question") {
                            VStack {
                                HStack(alignment: .center) {
                                    Spacer()
                                    Text("\(table[numForArr]) * \(currentTable) = ?")
                                        .font(.title.bold())
                                        .foregroundColor(.green)
                                    Spacer()
                                }
                                
                                TextField("Enter value", value: $userAnswer, format: .number)
                                    .keyboardType(.decimalPad)
                                    .focused($amountFocus)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, 7)
                                    .bold()
                                    .font(.title2)
                                    .disabled(!buttonIsDisabled)
                                
                                Button("CHECK IT") {
                                    checkAnswer()
                                }
                                .font(.title3).bold()
                                .buttonStyle(.borderless)
                                .foregroundColor(!buttonIsDisabled ? .secondary : .orange)
                                .disabled(!buttonIsDisabled)
                                .disabled(userAnswer.words.isEmpty)
                            }
                        }
                    }
                    
                    ZStack {
                        if disableTextField {
                            Circle()
                                .stroke(answerIsCorrect ? .green : .red)
                                .frame(width: 120, height: 120)
                        }
                        
                        Text("\(correctAnswer)")
                            .font(.custom("MyType", size: 70).bold())
                            .foregroundColor(answerIsCorrect ? .green : .red)
                        
                        Image(disableLabel ? "" : arrayOfAnimals.randomElement()!)
                            .frame(width: 400, height: 200)
                            .padding(.bottom, 10)
                    }
                    
                    Group {
                        Text(disableLabel ? "Your answer - \(userAnswer)\nCorrect answer - \(correctAnswer)" : "")
                        Spacer()
                        
                        HStack {
                            Text("Score: \(currentScore) / \(maxQuestions)")
                                .padding(.trailing, 70)
                            Text("Question \(markerQuestions) / \(maxQuestions)")
                        }
                        .bold()
                    }
                    .multilineTextAlignment(.center)
                }
                .navigationTitle("KidsEducation")
                .navigationBarTitleDisplayMode(.inline)
                
                
                HStack {
                    Button(!buttonIsDisabled ? "START GAME" : "RESTART") {
                        startGameBTN()
                    }
                    .buttonStyle(.borderedProminent)
                    .bold()
                    .padding(.trailing, 40)
                    
                    
                    Button("NEXT QUESTION") {
                        nextQuestion()
                    }
                    .buttonStyle(.borderedProminent)
                    .bold()
                    .disabled(!buttonIsDisabled)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountFocus = false
                    }
                }
            }
        }
        .alert("Game over", isPresented: $theEndGame) {
            Button("New Game", action: startGameBTN)
        } message: {
            Text("Your score: \(currentScore) / \(maxQuestions)")
        }
    }
    
    func startGameBTN() {
        userAnswer = 0
        currentScore = 0
        numForArr = Int.random(in: 0...9)

        buttonIsDisabled.toggle()
        disableLabel = false
        answerIsCorrect = false
        disableTextField = false
        
        markerQuestions = 0
        theEndGame = false
    }
    
    func checkAnswer() {
        correctAnswer = table[numForArr] * currentTable

        if correctAnswer == userAnswer {
            answerIsCorrect = true
        } else {
            answerIsCorrect = false
        }
        
        disableLabel = true
        disableTextField = true
                
        if markerQuestions == maxQuestions {
            theEndGame = true
        }
    }
    
    func nextQuestion() {
        if correctAnswer == userAnswer {
            currentScore += 1
        }
        
        disableTextField = false
        disableLabel = false
        userAnswer = 0
        numForArr = Int.random(in: 0...9)
        markerQuestions += 1
        
        if markerQuestions == maxQuestions {
            theEndGame = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
