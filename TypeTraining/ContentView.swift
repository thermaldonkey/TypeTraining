//
//  ContentView.swift
//  TypeTraining
//
//  Created by Brad Rice on 3/28/25.
//

import SwiftUI

/*
 Image(systemName: "leaf.circle.fill")
     .imageScale(.large)
     .foregroundStyle(.green)
 Text("Grass")
 
 Image(systemName: "drop.circle.fill")
     .imageScale(.large)
     .foregroundStyle(.blue)
 Text("Water")
 
 Image(systemName: "flame.circle.fill")
     .imageScale(.large)
     .foregroundStyle(.red)
 Text("Fire")
 */
enum PokemonType: CaseIterable, Comparable {
    case grass, fire, water
    
    func stringValue() -> String {
        switch self {
        case .grass:
            return "Grass"
        case .fire:
            return "Fire"
        case .water:
            return "Water"
        }
    }
}

extension PokemonType {
    static func <(lhs: PokemonType, rhs: PokemonType) -> Bool {
        switch (lhs, rhs) {
        case (.grass, .fire):
            return true
        case (.water, .grass):
            return true
        case (.fire, .water):
            return true
        default:
            return false
        }
    }
}

struct ContentView: View {
    private let roundTotal: Int = 10
    
    @State private var gameOver: Bool = false
    @State private var currentRound: Int = 1
    @State private var roundOver: Bool = false
    @State private var scoreTitle: String = ""
    @State private var shouldWinRound: Bool = true
    @State private var enemyType: PokemonType = .grass
    @State private var score: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                Text("Your rival sent out a \(enemyType.stringValue())-type Pokemon!")
                Text("Which type would you use to \(shouldWinRound ? "win" : "lose")?")
                HStack {
                    ForEach(PokemonType.allCases, id: \.self) { tipe in
                        Button(tipe.stringValue()) {
                            chooseType(as: tipe)
                        }
                        .padding()
                    }
                }
            }
        }
        .alert(scoreTitle, isPresented: $roundOver) {
            Button("Continue", action: nextRound)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game over!", isPresented: $gameOver) {
            Button("Restart", action: restartGame)
        } message: {
            Text("Your final score is \(score)")
        }
    }
    
    func restartGame() {
        currentRound = 1
        score = 0
    }
    
    func chooseType(as chosenType: PokemonType) {
        currentRound += 1
        let success = shouldWinRound ? (chosenType > enemyType) : (chosenType < enemyType)
        
        if success {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Oops, that's not right!"
        }
        
        roundOver = true
    }
    
    func nextRound() {
        if currentRound > roundTotal {
            gameOver = true
            return
        }
        shouldWinRound = Bool.random()
        enemyType = PokemonType.allCases.randomElement() ?? .grass
    }
}


#Preview {
    ContentView()
}
