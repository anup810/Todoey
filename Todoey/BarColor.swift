//
//  BarColor.swift
//  Todoey
//
//  Created by Anup Saud on 2024-06-24.
//

import UIKit

class BarColor{
    func barAppearance(for navigationController: UINavigationController?){
        let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor.systemCyan  
                appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                
                if let navigationBar = navigationController?.navigationBar {
                    navigationBar.standardAppearance = appearance
                    navigationBar.scrollEdgeAppearance = appearance
                }
        
        
    }
    
}
