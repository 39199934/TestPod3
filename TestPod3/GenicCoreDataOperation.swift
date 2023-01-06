//
//  GenicCoreDataOperation.swift
//  TestPod3
//
//  Created by rolodestar on 2023/1/5.
//

import Foundation
import CoreData

protocol GenicDataProtocol:Identifiable{
//    var context : NSManagedObjectContext{get set}
    
    //实例构建一个数据库对象
    func createNSManagedObject(context : NSManagedObjectContext) -> NSManagedObject
    
    //将数据库对象转换更新本实例
    func convertNSManagedObjectToSelf(obj: NSManagedObject) -> Self?
    //用本实例数据更新数据库对象
    func updateNSManagedObject( obj: inout NSManagedObject)
    
    //用数据库对象初始化构建一个实例
    init?(obj: NSManagedObject)
    
    //数据标识符，唯一
    var id: UUID{get set}
}


class GenicCoreDataOperation<T: GenicDataProtocol>: ObservableObject{
    lazy var context = PersistenceController.shared.container.viewContext
    var entityName: String
    
    @Published var allItems:[T]
    @Published var searchResults:[T]
    init(entityName: String){
        self.entityName = entityName
        allItems = []
        searchResults = []
        let _ = fetchAll()
    }
    func insert(item: T) -> Bool{
        do{
            let _ = item.createNSManagedObject(context: context)
            try context.save()
            allItems.append(item)
            return true
        }catch{
            return false
        }
    }
    func getItem(item: T) -> NSManagedObject?{
        let request = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
        let predicate = NSPredicate(format: "%K == %@", "id", item.id as CVarArg)
        request.predicate = predicate
        do{
            let results =  try context.fetch(request)
            if results.count >= 1{
                return results[0]
            }
            
           
        }catch{
            return nil
        }
        return nil
    }
    func delete(item: T) -> Bool{
        if let itemObj = getItem(item: item){
            context.delete(itemObj )
            do{
                try context.save()
                let _ = fetchAll()
                return true
            }catch{
                return false
            }
        }
        return false
    }
    func updagte(item: T) -> Bool{
        if var itemObj = getItem(item: item){
            item.updateNSManagedObject(obj: &itemObj)
            do{
                try context.save()
                let _ = fetchAll()
                return true
            }catch{
                return false
            }
        }
        do{
            try context.save()
            return true
        }catch{
            return false
        }
    }
    func fetchAll() -> [T]{
        let request = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
        do{
            
            let objs =  try context.fetch(request)
            self.allItems = []
            for obj in objs{
                if let t = T(obj: obj){
                    allItems.append(t)
                }
            }
            return self.allItems
        }catch{
            return []
        }
    }
    func search(by predicate: NSPredicate = NSPredicate(format: "", "")) -> [T]{
        let request = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
        request.predicate = predicate
        do{
            let objs =  try context.fetch(request)
            self.searchResults = []
            for obj in objs{
                if let t = T(obj: obj){
                    searchResults.append(t)
                }
            }
            return self.searchResults
            
        }catch{
            return []
        }
    }
    
}

//
//class DataGenic<T: NSManagedObject>: GenicDataProtocol{
//
//
//    func updateNSManagedObject(obj: inout NSManagedObject) {
//        if let t = obj as?  Test{
//            t.id = self.id
//            t.name = self.name
//
//        }
//    }
//
//    func convertNSManagedObjectToSelf(obj: NSManagedObject) -> Self? {
//        if let t = obj as?  Test{
//            self.id = t.id!
//            self.name = t.name!
//            return self
//        }
//        return nil
//
//    }
//
////    var id: Identifiable
//
//    var id: UUID
//
////    var context: NSManagedObjectContext
//
//    func createNSManagedObject(context : NSManagedObjectContext) -> NSManagedObject {
//        let t = Test(context: context)
//        t.id = self.id
//        t.name = self.name
//        return t
//    }
//
//    var name: String = ""
//
//    required init?(obj: NSManagedObject){
//        if let t = obj as? Test{
//            id = t.id!
//            name = t.name!
//        }else{
//            return nil
//        }
//
//    }
//    init(n: String){
//
////        self.context = PersistenceController.shared.container.viewContext
//        id = UUID()
//
//        self.name = n
//    }
//}
