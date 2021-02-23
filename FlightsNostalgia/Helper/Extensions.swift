/*
    Vlad Grisko Extensions File
    Place all usefull extensions of IOS classes here to avoid copying
*/

import UIKit

extension UIView {
    func pin(view: UIView, with insets: UIEdgeInsets) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: insets.bottom),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: insets.right)
        ])
    }
    
    func clean() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
