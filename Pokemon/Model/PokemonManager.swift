//
//  Pokemon.swift
//  Pokemon
//
//  Created by Eder Barreto Oliveira on 06/07/21.
//

import UIKit

class PokemonManager {
    static let shared = PokemonManager()

    struct PokemonList: Codable {
        let pokemon: [Pokemon]
    }

    struct Pokemon: Codable {
        let name: String?
        let img: String?
        let height: String?
        let weight: String?
    }
    
    enum ErrorType: Swift.Error {
        case businessError(Error)
        case networkError(Error)
    }
    
    public func getAllPokemons<CodableObject: Codable>(completion: @escaping (_ result: Result<CodableObject?, ErrorType>) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json") else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            guard let data = data else {
                completion(.failure(.networkError(err!)))
                return }
            do {
                let data = try JSONDecoder().decode(CodableObject.self, from: data)
                completion(.success(data))
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
