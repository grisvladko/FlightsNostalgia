//
//  CollectionViewCell.swift
//  FlightsNostalgia
//
//  Created by hyperactive on 07/02/2021.
//

import UIKit

class FormItemCollectionViewCell: UICollectionViewListCell {
    var formItem: UIView? {
        didSet {
            if formItem != nil {
                contentView.pin(view: formItem!, with: .zero)
            }
        }
    }
}

