//
//  SelfResizingCellInCollectionView.swift
//  BaseProject
//
//  Created by Michael Seven on 11/28/19.
//  Copyright © 2019 Michael Seven. All rights reserved.
//

// this is setup to auto resizing cell as their content

import UIKit

class SelfResizingCellInCollectionView: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: FlowLayout! {
        didSet {
            collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var numberOfRows: Int = 1
    let spaceBetweenCell: CGFloat = 10
    var totalWidthPerRow: CGFloat = 0

    let items: [String] = [
        "Lorem ipsum dolor sit amet, consectetur",
        "adipiscing elit, sed do eiusmod tempor",
        "incididun",
        "Ut enim ad m",
        "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
        "dadasda",
        "dsdasda", "dasdadsa"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SimpleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SimpleCollectionViewCell")
    }

}

// MARK: - Collection view delegate & datasource
extension SelfResizingCellInCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleCollectionViewCell", for: indexPath) as! SimpleCollectionViewCell
        
        cell.titleLb.text = items[indexPath.item]
        cell.layer.borderWidth = 0.2
        cell.layer.borderColor = UIColor.red.cgColor
        cell.maxWidth = collectionView.bounds.width
        
        // calculate rows in collectionview to update height for UICollectionView
        let collectionViewWidth = view.frame.width
        let cellWidth = cell.titleLb.intrinsicContentSize.width
        let cellHeight = cell.titleLb.intrinsicContentSize.height
        print("width = \(cellWidth)")
        let dynamicCellWidth = cellWidth
        totalWidthPerRow += dynamicCellWidth + spaceBetweenCell
        if totalWidthPerRow > collectionViewWidth {
            numberOfRows += 1
            totalWidthPerRow = dynamicCellWidth + spaceBetweenCell
        }
        print("numberOfRows = \(numberOfRows)")
        collectionViewHeight.constant = CGFloat(numberOfRows) * cellHeight
        self.view.layoutIfNeeded()
        
        return cell
    }
    
}

// MARK: - Sub class UIColelctionViewFlowLayout to alignment left cell in view instead of the center in view
class FlowLayout: UICollectionViewFlowLayout {

    required override init() {super.init(); common()}
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder); common()}

    private func common() {
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }

    override func layoutAttributesForElements(
                    in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let att = super.layoutAttributesForElements(in:rect) else {return []}
        var x: CGFloat = sectionInset.left
        var y: CGFloat = -1.0

        for a in att {
            if a.representedElementCategory != .cell { continue }

            if a.frame.origin.y >= y { x = sectionInset.left }
            a.frame.origin.x = x
            x += a.frame.width + minimumInteritemSpacing
            y = a.frame.maxY
        }
        return att
    }
}
