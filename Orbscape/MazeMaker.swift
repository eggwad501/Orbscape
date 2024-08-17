//
//  MazeMaker.swift
//  Orbscape
//
// Project: Orbscape
// EID: nmt736, rw28469, ss79767, nae596
// Course: CS371L

import Foundation

// functions to be called outside of maze maker
protocol MazeGenerator{
    func createMaze(_ rows: Int, _ cols: Int) -> [[Int]]
}

// directions [right, down, left, up]
let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]

// class to generate the maze
class MazeMaker: MazeGenerator{
    
    // returns a 2D array that has the walls and open spaces
    func createMaze(_ rows: Int, _ cols: Int) -> [[Int]] {
        // entrance and finish is at the middle top/bot of the maze
        let startX = 0
        let startY = cols / 2
        let endX = rows - 1
        let endY = cols / 2
        
        // initially create a maze of only walls
        var maze = Array(repeating: Array(repeating: 1, count: cols), count: rows)
        var stack: [(Int, Int)] = [(startX-1, startY)]
        maze[startX][startY] = 0 // Start point
        maze[endX][endY] = 0 // End point
        
        // maze generates randomly
        while !stack.isEmpty {
            let currentPos = stack.last!
            let (currentX, currentY) = currentPos
            
            var neighbors = [(Int, Int)]()
            for direction in directions {
                let nextX = currentX + direction.0 * 2
                let nextY = currentY + direction.1 * 2
                
                if nextX > 0 && nextX < rows && nextY > 0 && nextY < cols-1 && (maze[nextX][nextY] == 1) {
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
}
