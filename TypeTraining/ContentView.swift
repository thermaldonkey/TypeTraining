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
    
    func icon() -> String {
        switch self {
        case .grass:
            return "leaf.circle.fill"
        case .fire:
            return "flame.circle.fill"
        case .water:
            return "drop.circle.fill"
        }
    }
    
    func color() -> Color {
        switch self {
        case .grass:
            return .green
        case .fire:
            return .red
        case .water:
            return .blue
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
                Text("Type Training")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                Spacer()
                Spacer()
                
                Text("Your rival sent out a Pokemon of type")
                    .foregroundStyle(.secondary)
                    .font(.subheadline.weight(.heavy))
                Text(enemyType.stringValue())
                    .font(.title.weight(.semibold))
                    .foregroundColor(enemyType.color())
                Text("Tap the type that would")
                    .foregroundStyle(.secondary)
                    .font(.subheadline.weight(.heavy))
                Text("\(shouldWinRound ? "WIN" : "LOSE")")
                    .font(.title.weight(.heavy))
                
                Spacer()
                
                VStack(spacing: 20) {
                    ForEach(PokemonType.allCases, id: \.self) { tipe in
                        Button(action: {
                            chooseType(as: tipe)
                        }) {
                            HStack {
                                Image(systemName: tipe.icon())
                                Text(tipe.stringValue())
                                    .font(.title.weight(.heavy))
                            }
                            .font(.system(size: 50))
                        }
                        .padding()
                        .frame(width: 250, height: 100)
                        .background(RoundedRectangle(cornerRadius: 8).fill(tipe.color()))
                        .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                ProgressView(value: Double(currentRound), total: Double(roundTotal)) {
                    Text("Battle!")
                } currentValueLabel: {
                    Text("Round \(currentRound)/\(roundTotal)")
                }
                .padding()
                .tint(.primary)
                .font(.subheadline.weight(.heavy))
                .foregroundStyle(.secondary)
                .background(.thinMaterial)
                
                Spacer()
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
