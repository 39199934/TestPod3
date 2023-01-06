//
//  ContentView.swift
//  TestPod3
//
//  Created by rolodestar on 2023/1/3.
//

import SwiftUI
import CoreData
import Alamofire
import SwiftyJSON

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Test.name, ascending: true)],
        animation: .default)
    private var tests: FetchedResults<Test>
    @State var viewText: String = "result"
    @ObservedObject var dataTest = DataTest()
    @State var searchTxt: String = ""
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("search", text: $searchTxt)
                    .onSubmit {
                        dataTest.search(name: searchTxt)
                    }
                Text(viewText)
                    .font(.title)
                
                Button("use class insert"){
                    dataTest.insert()
                }
                Button("use class delete"){
                    dataTest.clear()
                }
                Button("test alamofire"){
                    let chatRobotUrl :URL =  URL(string: "https://api.qingyunke.com/api.php")!
                    let requestParam :Parameters = [
                        "key": "free",
                        "appid": "0",
                        "msg": "你是谁"
                    ]
                    AF.request(chatRobotUrl,method: .get,parameters: requestParam).responseDecodable(of: ChatResult.self) { respon in
                        switch respon.result{
                        case .success(let cr):
                            self.viewText = cr.content
                        default:
                            self.viewText = "error"
                            
                            
                        }
                    }
                    
                }
                Button("test coredata"){
                    let t = Test(context: viewContext)
                    for i in 0..<10{
                        let t = Test(context: viewContext)
                        t.name = "name_\(i)"
                        t.id = UUID()
                        do {
                            try viewContext.save()
                        } catch {
                            // Replace this implementation with code to handle the error appropriately.
                            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                }
            }
            List {
                ForEach(tests ,id:\.id) { item in
                    NavigationLink {
                        Text(item.name ?? "no data")
                    } label: {
                        Text(item.name ?? "no data")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            List {
                ForEach(dataTest.searchResult,id:\.id) { item in
                    NavigationLink {
                        Text(item.name ?? "no data")
                    } label: {
                        Text(item.name ?? "no data")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            Text("Select an item")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { tests[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
