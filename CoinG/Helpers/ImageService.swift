//
//  ImageService.swift
//  CoinG
//
//  Created by Gleb Lanin on 17/03/2022.
//
import Foundation
import UIKit

class ImageService {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImage(withURL url: URL, completion: @escaping (_ image:UIImage?) -> ()){
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                completion(image)
            }
        }.resume()
    }
    
    static func getImage(withURL url: URL, completion: @escaping (_ image:UIImage?) -> ()){
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            downloadImage(withURL: url, completion: completion)
        }
    }
}
