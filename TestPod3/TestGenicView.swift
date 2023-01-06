//
//  TestGenicView.swift
//  TestPod3
//
//  Created by rolodestar on 2023/1/5.
//

import SwiftUI

struct TestGenicView: View {
    @ObservedObject var data = GenicCoreDataOperation<TestDataGenic>(entityName: "Test")
    @State var searchStr : String = ""
    var body: some View {
        NavigationView{
            VStack{
                Button("refresh"){
                    data.fetchAll()
                }
                Button("insert"){
                    let item = TestDataGenic(n: "name _\(data.allItems.count)")
                    data.insert(item: item)
                }
                Button("delete first"){
                    data.delete(item: data.allItems[0])
                }
                TextField("search", text: $searchStr)
                    .onSubmit {
                        let pre = NSPredicate(format: "name CONTAINS %@", searchStr)
                        data.search(by: pre)
                    }
                
            }
            VStack{
                List(){
                    Text("all have:\(data.allItems.count)")
                    if(searchStr.isEmpty){
                        ForEach(data.allItems){item in
                            HStack{
                                Text(item.id.uuidString)
                                Spacer()
                                Text(item.name)
                                Button("change name")
                                {
                                    withAnimation {
                                        item.name = "Change name"
                                        data.updagte(item: item)
                                    }
                                    
                                }
                            }
                        }
                    }
                    else{
                        ForEach(data.searchResults){item in
                            HStack{
                                Text(item.id.uuidString)
                                Spacer()
                                Text(item.name)
                                Button("change name")
                                {
                                    withAnimation {
                                        item.name = "Change name"
                                        data.updagte(item: item)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TestGenicView_Previews: PreviewProvider {
    static var previews: some View {
        TestGenicView()
    }
}
