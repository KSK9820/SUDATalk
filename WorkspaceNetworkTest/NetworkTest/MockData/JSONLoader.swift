//
//  JSONLoader.swift
//  WorkspaceNetworkTest
//
//  Created by 김수경 on 1/1/25.
//

import Foundation

class JSONLoader {
    static func loadData(filename: String) -> Data? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Error: 파일 \(filename).json 을 찾을 수 없습니다1.")
            
            return nil
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Error: \(filename).json 로드 중 에러 발생1 - \(error)")
            
            return nil
        }
    }
    
    static func loadDecodedData<T: Decodable>(fileName: String, type: T.Type) -> T? {
          guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
              print("Error: 파일 \(fileName).json 을 찾을 수 없습니다2.")
              return nil
          }

          do {
              let data = try Data(contentsOf: url)
              let decoder = JSONDecoder()
              
              return try decoder.decode(T.self, from: data)
          } catch {
              print("Error: \(fileName).json 로드 중 에러 발생2 - \(error)")
              return nil
          }
      }
}
