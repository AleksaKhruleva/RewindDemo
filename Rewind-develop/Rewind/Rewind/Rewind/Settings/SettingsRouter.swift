//
//  SettingsRouter.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 06.03.2024.
//

import UIKit

final class SettingsRouter {
    private weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func presentAddTag() {
        let vc = AddTagBuilder.build()
        if let settingsView = view as? SettingsViewController {
            vc.addTagHandler = { tag in
                settingsView.presenter?.addTag(tag)
            }
            view?.present(vc, animated: true)
        }
    }
}
