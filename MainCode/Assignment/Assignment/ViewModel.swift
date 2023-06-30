//
//  ViewModel.swift
//  Assignment
//
//  Created by Sudeep Sharma on 29/06/23.
//

import UIKit

class ViewModel{
    
    enum ResponseType{
        case success
        case failure
    }
    
    init() {
        Task.detached(operation: { [unowned self] in
            await self.getData()
        })
    }
    
    var dataSendToController: (ResponseType)->() = {_ in }
    private (set) var screenData:BaseModel!{
        didSet{
            dataSendToController(.success)
        }
    }
    
    
    func getData() async {
        do {
            screenData = try await NetworkHelper.shared.callAPI(name: .facilities, type: .GET, model: BaseModel.self)
        }
        catch let error {
            print("Error faced in fetching data \(error.localizedDescription)")
            dataSendToController(.failure)
        }
    }
    
    

}
