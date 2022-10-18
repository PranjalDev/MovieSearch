//
//  MovieViewModel.swift
//  MovieProject
//
//  Created by Pranjal Verma on 18/10/22.
//

import Foundation
import UIKit

struct MovieViewModel {
    
    func loadImage(url: URL, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let urlSession = URLSession.shared
            urlSession.dataTask(with: request) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                completion(image)
            }.resume()
        }
    }
    
    func getData(searchText: String, pageNo: Int, completion: @escaping (MovieListModel) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: "http://www.omdbapi.com/?s=\(searchText)&page=\(pageNo)&apikey=aefe4863") else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let urlSession = URLSession.shared
            urlSession.dataTask(with: request) { data, response, error in
                do {
                    let jsonData = try JSONDecoder().decode(MovieListModel.self, from: data!)
                    completion(jsonData)
                } catch {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }
}
