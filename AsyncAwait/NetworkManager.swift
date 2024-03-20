//
//  NetworkManager.swift
//  AsyncAwait
//
//  Created by Vlad on 20.3.24..
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchCourses(completion: @escaping(Result<[Course], NetworkError>) -> Void) {
        guard let url = URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_courses") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses = try decoder.decode([Course].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(courses))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
            
        }.resume()
    }
    
    func fetchCourses() async throws -> [Course] {
        guard let url = URL(string: "https://swiftbook.ru//wp-content/uploads/api/api_courses") else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let courses: [Course]
        
        do {
            courses = try decoder.decode([Course].self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
        
        return courses
    }
    
    func fetchCoursesWithContinuation() async throws -> [Course] {
        try await withCheckedThrowingContinuation { continuation in
            fetchCourses { result in
                switch result {
                case .success(let courses):
                    continuation.resume(returning: courses)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
