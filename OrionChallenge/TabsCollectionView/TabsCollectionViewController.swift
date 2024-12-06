//
// OrionChallenge
// Copyright © 2024 Jean-Étienne Parrot. All rights reserved.
//

import UIKit

class TabsCollectionViewController: UIViewController {

    private let viewModel: TabsCollectionViewModel

    private var collectionView: UICollectionView!
    private lazy var toolbarDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidTouch))

    private enum Constants {
        static let cellSpacing: CGFloat = 10
    }

    init(viewModel: TabsCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.cellSpacing
        layout.minimumLineSpacing = Constants.cellSpacing

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BrowserTabCollectionViewCell.nib, forCellWithReuseIdentifier: BrowserTabCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .darkGray
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Constants.cellSpacing, bottom: 0, right: Constants.cellSpacing)
        collectionView.alwaysBounceVertical = true
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.toolbar.isTranslucent = true
        setToolbarItems([
            UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addTabButtonDidTouch)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            toolbarDoneButton
        ], animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.toolbar.defaultAppearance()
    }

}

extension TabsCollectionViewController {

    @objc func addTabButtonDidTouch(_ barButtonItem: UIBarButtonItem) {
        viewModel.addAndSelectTab()
        openLastSelectedTab()

        toolbarDoneButton.isEnabled = viewModel.shouldEnableDoneButton
        collectionView.reloadData()
    }

    @objc func doneButtonDidTouch(_ barButtonItem: UIBarButtonItem) {
        openLastSelectedTab()
    }

    private func openLastSelectedTab() {
        let pagesContainer = PagesContainerViewController(viewModel: viewModel, initialIndex: viewModel.lastSelectedTabIndex ?? 0)
        pagesContainer.browserDelegate = self
        navigationController?.pushViewController(pagesContainer, animated: true)
    }

}

extension TabsCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tabs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowserTabCollectionViewCell.reuseIdentifier, for: indexPath) as! BrowserTabCollectionViewCell
        if let browserTab = viewModel.tab(at: indexPath.item) {
            cell.configure(with: browserTab) { [self] in
                viewModel.deleteTab(at: indexPath.item)
                toolbarDoneButton.isEnabled = viewModel.shouldEnableDoneButton
                collectionView.deleteItems(at: [indexPath])
                collectionView.reloadItems(at: [indexPath])
            }
        }
        return cell
    }

}

extension TabsCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectTab(at: indexPath.item)
        let pagesContainer = PagesContainerViewController(viewModel: viewModel, initialIndex: indexPath.item)
        pagesContainer.browserDelegate = self
        navigationController?.pushViewController(pagesContainer, animated: true)
    }

}

extension TabsCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeClass = traitCollection.horizontalSizeClass
        let itemsPerRow: CGFloat = (sizeClass == .compact && traitCollection.verticalSizeClass == .regular) ? 2 : 3

        let minimumInteritemSpacing = Constants.cellSpacing
        let totalSpacing = (itemsPerRow - 1) * minimumInteritemSpacing + collectionView.contentInset.left + collectionView.contentInset.right
        let availableWidth = collectionView.bounds.width - totalSpacing
        let cellWidth = availableWidth / itemsPerRow

        let screenAspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
        let cellHeight = cellWidth * screenAspectRatio * 0.7

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }

}

extension TabsCollectionViewController: BrowserViewControllerDelegate {

    func browserViewController(_ browserViewController: BrowserViewController, didUpdateTab tab: BrowserTab, withTitle title: String?, image: UIImage, url: URL?) {
        viewModel.update(tab: tab, withTitle: title, image: image, url: url)
        collectionView.reloadData()
    }

}

fileprivate extension BrowserTabCollectionViewCell {

    func configure(with browserTab: BrowserTab, closeAction: @escaping (() -> Void)) {
        self.configure(image: browserTab.image, title: browserTab.title, icon: nil, closeAction: closeAction)
    }

}
