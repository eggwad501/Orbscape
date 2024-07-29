//
//  MazeMaker.swift
//  Orbscape
//
//  Created by Nhat Tran on 7/29/24.
//

import Foundation

protocol MazeGenerator{
    func createMaze(_ rows: Int, _ cols: Int) -> [[Int]]
    func printMaze(_ maze: [[Int]])
}

// directions [right, down, left, up]
let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]


class MazeMaker: MazeGenerator{
    
    func createMaze(_ rows: Int, _ cols: Int) -> [[Int]] {
        // starts and ends at the middle top/bot of the maze
        let startX = 0
        let startY = cols / 2
        let endX = rows - 1
        let endY = cols - 1
        
        // initially create a maze of only walls
        var maze = Array(repeating: Array(repeating: 1, count: cols), count: rows)
        var stack: [(Int, Int)] = [(startX, startY)]
        maze[startX][startY] = 0 // Start point
        maze[endX][endY] = 0 // End point
        
        // I HATE RECURSION! I HATE RECURSION! I HATE RECURSION!
        while !stack.isEmpty {
            let currentPos = stack.last!
            let (currentX, currentY) = currentPos
            
            var neighbors = [(Int, Int)]()
            
            for direction in directions {
                let nextX = currentX + direction.0 * 2
                let nextY = currentY + direction.1 * 2
                
                if nextX >= 0 && nextX < rows && nextY >= 0 && nextY < cols && maze[nextX][nextY] == 1 {
                    neighbors.append((nextX, nextY))
                }
            }
            
            if !neighbors.isEmpty {
                let chosen = neighbors.randomElement()!
                let (nx, ny) = chosen
                maze[(currentX + nx) / 2][(currentY + ny) / 2] = 0
                maze[nx][ny] = 0
                stack.append((nx, ny))
            } else {
                stack.removeLast()
            }
        }
        
        return maze
    }

    func printMaze(_ maze: [[Int]]) {
        var result: String = ""
        for row in maze {
            // O is moveable space, X is wall
            let line = row.map { $0 == 0 ? "O " : "X " }.joined()
            print(line)
            result += line + "\n"
        }
    }
}
