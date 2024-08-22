//
//  ProfileRouter.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 22.08.2024.
//

import UIKit

protocol ProfileRouterProtocol: RouterMainProtocol {
    func initialViewController()
}

class ProfileRouter: ProfileRouterProtocol {
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(assemblyBuilder: AssemblyBuilderProtocol) {
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        guard (assemblyBuilder?.createProfileModule(router: self)) != nil else { return }
    }
}
