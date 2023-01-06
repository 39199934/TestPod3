//
//  DataTest.swift
//  TestPod3
//
//  Created by rolodestar on 2023/1/4.
//

import Foundation
import CoreData

class DataTest: ObservableObject{
    @Published var searchResult:[Test]
    lazy var context = PersistenceController.shared.container.viewContext
    init(){
        searchResult = []
    }
    func insert(){
        let request = NSFetchRequest<Test>(entityName: "Test")
        do{
            let results = try context.fetch(request)
            let count = results.count
            let n = Test(context: context)
            n.name = "nameByClass_\(count)"
            n.id = UUID()
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    func clear(){
        let request = NSFetchRequest<Test>(entityName: "Test")
        do{
            let results = try context.fetch(request)
            for test in results{
                context.delete(test)
            }
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    func search(name: String){
        let request = NSFetchRequest<Test>(entityName: "Test")
        request.predicate = NSPredicate(format: "name CONTAINS %@", name)
        do{
            let results = try context.fetch(request)
            searchResult = results
        }catch{
            print(error.localizedDescription)
        }
    }
}
