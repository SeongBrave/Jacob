//
//  Home_vc.swift
//  Jacob
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import RxSwift
import UtilCore
import EmptyDataView
import MJRefresh

class Home_vc: Empty_TVc {
    
    /****************************Storyboard UI设置区域****************************/
    
    @IBOutlet weak var home_tv: UITableView!
    
    /*----------------------------   自定义属性区域    ----------------------------*/
    
    // 顶部刷新
    let header = MJRefreshGifHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
     
    /****************************Storyboard 绑定方法区域****************************/
    var manageVm:Home_vm?
     
    var home_list = [Home_model]() {
        didSet {
            self.home_tv.reloadData()
        }
    }
     
    /**************************** 以下是方法区域 ****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    /**
     界面基础设置
     */
    override func setupUI() {
        
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(Home_vc.headerRefresh))
        self.home_tv.mj_header = header
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(Home_vc.footerRefresh))
        self.home_tv.mj_footer = footer
        self.home_tv.dzn_tv_emptyDataSource = self
        self.home_tv.dzn_tv_emptyDelegate = self
        self.home_tv.tableFooterView = UIView()
        self.home_tv.estimatedRowHeight = 100  //  随便设个不那么离谱的值
        self.home_tv.rowHeight = UITableView.automaticDimension
        ///隐藏滑动条
        self.home_tv.showsVerticalScrollIndicator = false
         
    }

    /**
     app 主题 设置
     */
    override func setViewTheme() {
        
    }

    /**
     绑定到viewmodel 设置
     */
    override func bindToViewModel() {

        /**
         *  初始化viewmodel
         */
         
        self.manageVm = Home_vm(
            input: (
                firstLoadTriger:Observable.just("").map{_ in},
                refreshTriger:  rx.sentMessage(#selector(Home_vc.headerRefresh)).map{_ in},
                loadMoreTriger: rx.sentMessage(#selector(Home_vc.footerRefresh)).map{_ in}
        ))

        self.manageVm?
            .homeElements
            .asObservable()
            .subscribe(onNext: {[unowned self] (list) in
                self.errorPageView.isHidden = true
                self.showEmptyView = true
                self.home_list = list
            })
            .disposed(by: disposeBag)

        /**
         *  通过vm 的loding 显示 加载进度
         */
        self.manageVm?
            .loading.asObservable()
            .bind(to: self.view.rx_loading)
            .disposed(by: disposeBag)

        self.manageVm?
            .pullLoading
            .asObservable()
            .subscribe(onNext: {[unowned self] (isLoading) in
                if isLoading {
                    self.home_tv.mj_header.endRefreshing()
                }
            })
            .disposed(by: disposeBag)

        self.errorPageView
            .reloadSubject
            .bind(to: self.manageVm!.reloadTrigger)
            .disposed(by: disposeBag)
        /**
         *  通过vm 的hasNextPage 配置数据是否加载完毕
         */
        self.manageVm?
            .hasNextPage.asDriver()
            .asObservable()
            .subscribe(onNext: {[unowned self] (hasNextPage) in
                if !hasNextPage {
                    self.home_tv.mj_footer.endRefreshing()
                    self.footer.endRefreshingWithNoMoreData()
                }else {
                    /** 重置没有更多的数据（消除没有更多数据的状态） */
                    self.footer.resetNoMoreData()
                }
            })
            .disposed(by: disposeBag)
            
        //刷新界面错误处理
        self.manageVm?
            .refresherror
            .asObserver()
            .bind(to: self.rx_showerrorpage)
            .disposed(by: disposeBag)

        self.manageVm?
            .error
            .asObserver()
            .bind(to: self.view.rx_error)
            .disposed(by: disposeBag)

        guard let manageVm = self.manageVm else {
            return
        }
        Observable.of(manageVm.error, manageVm.refresherror)
            .merge()
            .subscribe(onNext: {[unowned self] (_) in
                self.home_tv.mj_footer.endRefreshing()
            }).disposed(by: disposeBag)
        
    }
}

// MARK: - 自定义方法
extension  Home_vc {

    // 顶部刷新
    @objc func headerRefresh() {
        
    }
    
    @objc func footerRefresh() {
        
    }
}

// MARK: UITableViewDelegate
extension  Home_vc: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.home_list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.home_list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Home_tCell", for: indexPath) as! Home_tCell
        cell.item = item
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
// MARK: UITableViewDelegate
extension  Home_vc: UITableViewDelegate {

    /// 点击行事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.home_list[indexPath.row]
        _ = model.uri.openURL()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 159
    }
}

/// 空数据数据代理
extension  Home_vc :EmptyDataSource {

    func verticalOffset(emptyView scrollView: UIScrollView) -> CGFloat {
        return 0
    }

    func description(emptyView scrollView: UIScrollView) -> NSAttributedString? {
        var attributes: [NSAttributedString.Key:Any] = [:]
        attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 17)
        attributes[NSAttributedString.Key.foregroundColor] = UIColor.red
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        attributes[NSAttributedString.Key.paragraphStyle] = paragraph
        let attributedString =  NSMutableAttributedString(string: "商品列表数据为空啊", attributes: nil)
        let range = (attributedString.string as NSString).range(of: "列表数据")
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.6784313725, blue: 0.9450980392, alpha: 1)], range: range)
        return attributedString
    }
}

