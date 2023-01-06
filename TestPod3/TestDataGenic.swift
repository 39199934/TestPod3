//
//  TestDataGenic.swift
//  TestPod3
//
//  Created by rolodestar on 2023/1/5.
//

import Foundation
import CoreData


class TestDataGenic: GenicDataProtocol{
    
    
    func updateNSManagedObject(obj: inout NSManagedObject) {
        if let t = obj as?  Test{
            t.id = self.id
            t.name = self.name
            
        }
    }
    
    func convertNSManagedObjectToSelf(obj: NSManagedObject) -> Self? {
        if let t = obj as?  Test{
            self.id = t.id!
            self.name = t.name!
            return self
        }
        return nil
        
    }
    
//    var id: Identifiable
    
    var id: UUID
    
//    var context: NSManagedObjectContext
    
    func createNSManagedObject(context : NSManagedObjectContext) -> NSManagedObject {
        let t = Test(context: context)
        t.id = self.id
        t.name = self.name
        return t
    }
    
    var name: String = ""
    
    required init?(obj: NSManagedObject){
        if let t = obj as? Test{
            id = t.id!
            name = t.name!
        }else{
            return nil
        }
        
    }
    init(n: String){
       
//        self.context = PersistenceController.shared.container.viewContext
        id = UUID()
        
        self.name = n
    }
}
