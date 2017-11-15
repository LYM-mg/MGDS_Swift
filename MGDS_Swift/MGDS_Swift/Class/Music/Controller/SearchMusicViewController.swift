//
//  SearchViewController.swift
//  ProductionReport
//
//  Created by i-Techsys.com on 17/2/13.
//  Copyright © 2017年 i-Techsys. All rights reserved.
//

import UIKit

private let KSearchResultCellID = "KSearchResultCellID"
private let KSearchHistoryCellID = "KSearchHistoryCellID"
private let KHeaderReusableViewID = "KHeaderReusableViewID"
private let KHotSearchCellID = "KHotSearchCellID"
private let KHistoryHeaderViewID = "KHistoryHeaderViewID"
private let KSearchResultHeaderViewID = "KSearchResultHeaderViewID"

class SearchMusicViewController: UIViewController {
    fileprivate var hotSearchView: HotSearchView?
    // MARK: - 懒加载属性
    fileprivate lazy var tableView: UITableView = { [unowned self] in
        //        let tb = UITableView(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: self.view.mg_height))
        let tb = UITableView()
        tb.backgroundColor = UIColor.white
        tb.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tb.dataSource = self
        tb.delegate = self
        tb.isHidden = true
        tb.rowHeight = 60
        tb.tableFooterView = UIView()
//        tb.estimatedRowHeight = 60  // 设置估算高度
//        tb.rowHeight = UITableViewAutomaticDimension // 告诉tableView我们cell的高度是自动的
        tb.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        tb.register(UINib(nibName: "SearchResultHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: KSearchResultHeaderViewID)
        return tb
    }()
    @objc fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        let fl = UICollectionViewFlowLayout()
        fl.minimumLineSpacing = 4
        fl.minimumInteritemSpacing = 0
        fl.headerReferenceSize = CGSize(width: MGScreenW, height: 35)
        fl.itemSize = CGSize(width: MGScreenW, height: 44)
        
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: fl)
        cv.frame = CGRect(x: 0, y: 0, width: MGScreenW, height: self.view.mg_height)
        cv.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        cv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cv.dataSource = self
        cv.delegate = self
        cv.alwaysBounceVertical = true
        cv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
        cv.register(SearchHistoryCell.classForCoder(), forCellWithReuseIdentifier: KSearchHistoryCellID)
         cv.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: KHotSearchCellID)
        cv.register(UINib(nibName: "HistoryHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: KHistoryHeaderViewID)
        return cv
    }()

    fileprivate lazy var SearchMusicVM = SearchMusicViewModel()
    let searchBar = UISearchBar()
    fileprivate lazy var historyData = [[String: Any]]()
    fileprivate lazy var hotSearchArr: [String] = {[unowned self]  in
        let hotArr = [String]()
        return hotArr
    }()
    fileprivate lazy var songSearchArr = [SearchModel]()
    
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMainView()
        loadHotSearchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadHistorySearchData()
    }
    
    deinit {
        debugPrint("SearchViewController--deinit")
    }
}


// MARK: - setUpUI
extension SearchMusicViewController {
    fileprivate func setUpMainView() {
        view.backgroundColor = UIColor.white
        buildSearchBar()
        
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
             make.top.equalToSuperview().offset(MGNavHeight)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    fileprivate func buildSearchBar() {
        searchBar.frame = CGRect(x: -10, y: 0, width: MGScreenW * 0.9, height: 30)
        searchBar.placeholder = "请输入关键字查询歌曲"
        searchBar.barTintColor = UIColor.white
        searchBar.keyboardType = UIKeyboardType.default
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        for view in searchBar.subviews {
            for subView in view.subviews {
                if NSStringFromClass(subView.classForCoder) == "UINavigationButton" {
                    let btn = subView as? UIButton
                    btn?.setTitle("取消" , for: .normal)
                }
                if NSStringFromClass(subView.classForCoder) == "UISearchBarTextField" {
                    let textField = subView as? UITextField
                    textField?.tintColor = UIColor.gray
                }
            }
        }
    }
}

// MARK: - 加载数据
extension SearchMusicViewController {
    // 加载历史数据
    fileprivate func loadHistorySearchData() {
        DispatchQueue.global().async {
            if self.historyData.count > 0 {
                self.historyData.removeAll()
            }
            
            guard var historySearch = SaveTools.mg_getLocalData(key: MGSearchMusicHistorySearchArray) as? [[String : Any]] else { return }
            if historySearch.count > 15 {
                historySearch.removeLast()
            }
            self.historyData = historySearch
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // loadHotSearchData
    fileprivate func loadHotSearchData() {
        hotSearchArr.removeAll()
        let parameters = ["from":"ios","version":"5.5.6","channel":"appstore","operator":"1","format":"json","method":"baidu.ting.search.hot","page_num":"15"]
        NetWorkTools.requestData(type: .get, urlString: "http://tingapi.ting.baidu.com/v1/restserver/ting",parameters: parameters, succeed: { (response, err) in
            guard let result = response as? [String: Any] else { return }
            let dictArr = result["result"] as! [[String: Any]]
            for dict in dictArr {
                self.hotSearchArr.append(dict["word"] as! String)
            }
            self.collectionView.reloadData()
        }) { (err) in
            
        }
    }
}

// MARK: - TableView数据源  和 代理
extension SearchMusicViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if songSearchArr.count == 0 { return 0 }
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songSearchArr.count == 0 { return 0 }
        if section == 0 {
            return songSearchArr.first!.songArray.count
        }else if section == 1 {
            return songSearchArr.first!.albumArray.count
        }else if section == 2 {
            return songSearchArr.first!.artistArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: KSearchResultCellID)
        if cell == nil {
           cell = UITableViewCell(style: .subtitle, reuseIdentifier: KSearchResultCellID)
        }
        
        if indexPath.section == 0 {
            let model = songSearchArr.first!.songArray[indexPath.row]
            cell!.imageView?.image = #imageLiteral(resourceName: "default-user")
            cell!.textLabel?.text = model.songname
            cell!.detailTextLabel?.text = model.artistname
        }else if indexPath.section == 1 {
            let model = songSearchArr.first!.albumArray[indexPath.row]
            cell!.textLabel?.text = model.albumname
            cell!.detailTextLabel?.text = model.artistname
            cell!.imageView?.setImageWithURLString(model.artistpic, placeholder: #imageLiteral(resourceName: "default-user"))
        }else if indexPath.section == 2 {
            let model = songSearchArr.first!.artistArray[indexPath.row]
            cell!.textLabel?.text = model.artistname
            cell!.imageView?.setImageWithURLString(model.artistpic, placeholder: #imageLiteral(resourceName: "default-user"))
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var text = ""
        if indexPath.section == 0 {
            let model = songSearchArr.first!.songArray[indexPath.row]
            text = model.songname
        }else if indexPath.section == 1 {
            let model = songSearchArr.first!.albumArray[indexPath.row]
            text = model.albumname
        }else if indexPath.section == 2 {
            let model = songSearchArr.first!.artistArray[indexPath.row]
            text = model.artistname
        }
        pushTosearchResultView(withText: text)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = tableView.dequeueReusableHeaderFooterView(withIdentifier: KSearchResultHeaderViewID) as! SearchResultHeaderView
        if (section == 0) {
            head.titleLabel.text = "歌曲"
        } else if(section == 1){
            head.titleLabel.text = "专辑"
        } else{
            head.titleLabel.text = "歌手"
        }
        return head;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}


// MARK: - collectionView数据源 和 代理
extension SearchMusicViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return historyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KHotSearchCellID, for: indexPath)
            if hotSearchArr.count > 0 {
                if hotSearchView == nil {
                    let hotSearchView = HotSearchView(frame: CGRect(x: 0, y: 0, width: MGScreenW, height: 200), searchTitleText: "热门搜索", searchButtonTitleTexts: hotSearchArr, searchButton: {[unowned self] (btn) in
                        self.searchBar.text = btn?.currentTitle
                        self.loadProductsWithKeyword(self.searchBar.text!)
                        self.tableView.isHidden = false
                        self.searchBar.resignFirstResponder()
                    })
                    cell.addSubview(hotSearchView!)
                    self.hotSearchView = hotSearchView!
                    print(hotSearchView!.searchHeight)
//                    cell.frame = hotSearchView!.frame
//                    cell.layoutIfNeeded()

                    // IndexSet(index: 0)
                   let indexSet = IndexSet(integer: 0)
                   collectionView.reloadSections(indexSet)
                }
             }
             return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KSearchHistoryCellID, for: indexPath) as! SearchHistoryCell
            let dict = historyData[indexPath.item]
            cell.historyLabel.text = dict["searchFilter"] as! String?
            return cell
        }
    }

    // 清除历史搜索记录
    @objc fileprivate func clearHistorySearch() {
        SaveTools.mg_removeLocalData(key: MGSearchMusicHistorySearchArray)
        loadHistorySearchData()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var dict = historyData[indexPath.item]
        searchBar.text = dict["searchFilter"] as? String
        self.loadProductsWithKeyword(self.searchBar.text!)
        dict = self.historyData.remove(at: indexPath.item)
        historyData.insert(dict, at: 0)
        SaveTools.mg_SaveToLocal(value: historyData, key: MGSearchMusicHistorySearchArray)
        loadHistorySearchData()
        tableView.isHidden = false
        searchBar.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //如果是headerView
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KHistoryHeaderViewID, for: indexPath) as! HistoryHeaderView
            headerView.titleLabel.text = (indexPath.section == 0) ? "热门搜索" : "历史搜索"
            headerView.iconImageView.image = (indexPath.section == 0) ? #imageLiteral(resourceName: "home_header_hot"): #imageLiteral(resourceName: "search_history")
            headerView.moreBtn.isHidden = (indexPath.section == 0)
            headerView.moreBtnClcikOperation = {
                self.clearHistorySearch()
            }
            return headerView
        }
        
        return HistoryHeaderView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: MGScreenW, height: (self.hotSearchView == nil) ? 200 : (self.hotSearchView?.searchHeight)!)
        }
        return CGSize(width: MGScreenW, height: 44)
    }
    
    //设定页脚的尺寸为0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: MGScreenW, height: 0)
    }
}

// MARK: - UISearchBarDelegate
extension SearchMusicViewController: UISearchBarDelegate,UIScrollViewDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        tableView.isHidden = true
        searchBar.showsCancelButton = false
        songSearchArr.removeAll()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        // 写入到本地
        writeHistorySearchToUserDefault(searchFilter: searchBar.text!)
        //去除搜索字符串左右和中间的空格
        searchBar.text = searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        // 加载数据
        loadProductsWithKeyword(searchBar.text!)
        tableView.reloadData()
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            // 将tableView隐藏
            tableView.isHidden = true
            collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

// MARK: -  搜索网络加载数据
extension SearchMusicViewController {
    // MARK: -  本地数据缓存
    fileprivate func writeHistorySearchToUserDefault(searchFilter: String) {
        var historySearchs = SaveTools.mg_getLocalData(key: MGSearchMusicHistorySearchArray) as? [[String: Any]]
        if historySearchs != nil {
            for dict in historySearchs! {
                if dict["searchFilter"] as? String == searchFilter { print("已经缓存") ; return }
            }
        }else {
            historySearchs = [[String: Any]]()
        }
        var dict = [String: Any]()
        dict["searchFilter"] = searchFilter
        historySearchs?.insert(dict, at: 0)
        SaveTools.mg_SaveToLocal(value: historySearchs!, key: MGSearchMusicHistorySearchArray)
        loadHistorySearchData()
    }
    
    // MARK: -  搜索网络加载数据
    fileprivate func loadProductsWithKeyword(_ keyword: String) {
        songSearchArr.removeAll()
        // 1.显示指示器
        self.showHudInViewWithMode(view: self.view, hint: "正在查询数据", mode: .indeterminate, imageName: nil)
        let parameters = ["from":"ios","version":"5.5.6","channel":"appstore","operator":"1","format":"json","method":"baidu.ting.search.catalogSug","query":keyword]
        NetWorkTools.requestData(type: .get, urlString: "http://tingapi.ting.baidu.com/v1/restserver/ting",parameters: parameters, succeed: {[weak self] (response, err) in
            self?.hideHud()
            guard let result = response as? [String: Any] else { return }
            let model = SearchModel(dict: result)
            if model.songArray.isEmpty && model.albumArray.isEmpty && model.artistArray.isEmpty {
                self?.showHint(hint: "没有查询到结果")
                self?.tableView.reloadData()
                return
            }
            self?.songSearchArr.append(model)
            self?.tableView.reloadData()
        }) { (err) in
            self.hideHud()
            self.showHint(hint: "请求数据失败", imageName: "sad_face_icon")
        }
    }
}

// 跳转到下一个控制器搜索🔍
extension SearchMusicViewController {
    func pushTosearchResultView(withText text: String) {
        let result = MGSearchMusicResultVC()
        result.searchText = text
        navigationController?.pushViewController(result, animated: false)
    }
}

