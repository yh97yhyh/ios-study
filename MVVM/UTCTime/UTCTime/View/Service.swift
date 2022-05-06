//
//  Logic.swift
//  UTCTime
//
//  Created by MZ01-KYONGH on 2022/05/06.
//

import Foundation

class Service { // Logic
    let repository = Repository()
    
    var currentModel = Model(currentDateTime: Date())
    
    func fetchNow(onCompleted: @escaping (Model) -> Void) {
        repository.fetchNow { [weak self] entity in
            guard let self = self else { return }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm'Z'"

            guard let now = formatter.date(from: entity.currentDateTime) else { return }
            
            let model = Model(currentDateTime: now)
            self.currentModel = model
            
            onCompleted(model)
        }
    }
    
    func moveDay(day: Int) {
        guard let movedDay = Calendar.current.date(byAdding: .day,
                                                   value: day,
                                                   to: currentModel.currentDateTime) else {
            return
        }
        
        currentModel.currentDateTime = movedDay
    }
}
