//
//  ABManager.swift
//  TABDev
//
//  Created by ihenry on 2024/2/22.
//

import UIKit
import Cache

public class ABManager {
    
    public static var shared: ABManager = .init()
    private let session = URLSession.shared

    public var identifier = ""
    
    var abConfigFileURLString: String {
        "https://raw.githubusercontent.com/spm-market/AB/main/files/\(identifier).json"
    }
    
    private let cache = DiskCache<Data>(filename:"ab", expirationInterval: 30 * 24 * 60 * 60)
    private let keyString : String = "ab"
    
    var dic:[String:Any] = [:]

    private init() {
        Task(priority: .userInitiated) {
            try? await cache.loadFromDisk()
        }
    }
    
    /// 获取Bool值
    /// - Parameter key: 键值
    /// - Returns: Bool值
    public func boolForKey(key:String) -> Bool {
        guard let value = self.dic[key] as? Bool else {
            return false
        }
        return value
    }
    
    /// 获取String值
    /// - Parameter key: 键值
    /// - Returns: String值
    public func stringForKey(key:String) -> String {
        guard let value = self.dic[key] as? String else {
            return ""
        }
        return value
    }
    
    /// 获取Number值
    /// - Parameter key: 键值
    /// - Returns: Number值
    public func numberForKey(key:String) -> NSNumber {
        guard let value = self.dic[key] as? NSNumber else {
            return 0
        }
        return value
    }
    
    /// 更新AB数据
    public func refreshABData() async  {
        // 删除缓存
        await cache.removeValue(forKey: keyString)
        // 加载缓存
        await loadABData()
    }
    
    /// 加载AB数据
    public func loadABData() async {
        
        if Task.isCancelled { return }
        
        if let data = await cache.value(forKey: keyString) { // 如果有缓存
            
            return
        }

        await self.cache.setValue(nil, forKey: keyString)

        guard let url = URL(string: "https://raw.githubusercontent.com/BBC6BAE9/ab/main/xptv.json") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, response) = try await session.data(from: url)
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                self.dic = json
                await cache.setValue(data, forKey: self.keyString)
            }
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
}
