//
//  UserViewModel.swift
//  LearningAcademy
//
//  Created by Manish Parihar on 24.10.23.
//

import Foundation

final class UserViewModel: ObservableObject {
    
    @Published private(set) var users: [User] = []
    @Published private(set) var errors: NetworkingManager.NetworkingError?
    @Published private(set) var viewState: ViewState?
    @Published var hasError = false
    
    private(set) var offset = 10
    private(set) var totalUsers: Int?
    
    var isLoading:Bool {
        viewState == .loading
    }
    
    var isFetching:Bool {
        viewState == .fetching
    }
    
    
    func fetchUsers() async {
        reset()
        
        viewState = .loading
        
        defer { viewState = .fetching}
        
        do {
            
        } catch  {
            
        }
    }
}

extension UserViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

// Reset page
private extension UserViewModel {
    func reset() {
        if viewState == .finished {
            users.removeAll()
            offset = 10
            totalUsers = nil
            viewState = nil
        }
    }
}
