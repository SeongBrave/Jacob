//
//  Product_vc.swift
//  Jacob
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//


import RxSwift
import UtilCore
import EmptyDataView
import MJRefresh
import Bella
import Alice

class Product_vc: Empty_TVc {
    
    /****************************Storyboard UI设置区域****************************/

    @IBOutlet weak var product_tv: UITableView!
    /*----------------------------   自定义属性区域    ----------------------------*/
    // 顶部刷新
    let header = MJRefreshGifHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    /****************************Storyboard 绑定方法区域****************************/
    var manageVm:Product_vm?
    var productList = [Product_model]() {
        didSet {
            self.product_tv.reloadData()
        }
    }
    private lazy var leftBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 35)
        button.setImage(UIImage(named: "scanbtn", in: JacobCore.bundle, compatibleWith: nil), for: .normal)
        return button
    }()
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
        header.setRefreshingTarget(self, refreshingAction: #selector(Product_vc.headerRefresh))
        self.product_tv.mj_header = header
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: #selector(Product_vc.footerRefresh))
        self.product_tv.mj_footer = footer
        self.product_tv.dzn_tv_emptyDataSource = self
        self.product_tv.dzn_tv_emptyDelegate = self
        self.product_tv.tableFooterView = UIView()
        self.product_tv.estimatedRowHeight = 100  //  随便设个不那么离谱的值
        self.product_tv.rowHeight = UITableView.automaticDimension
        ///隐藏滑动条
        self.product_tv.showsVerticalScrollIndicator = false
        /**
         *  自定义 导航栏左侧 返回按钮
         */
        self.customLeftBarButtonItem()
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
        
        /// 这块需要注意 ，其实应该发两次请求， 一次是notification触发的就是在有网的时候， 另外一次就是HomePage_Vc 的viewWillAppear 触发的
        let firstLoadTriger = Observable.of(
            Observable.just("").map{_ in},
            NotificationCenter.default.rx.notification(Notification.Name(rawValue: Envs.notificationKey.loginSuccess), object: nil).map { _ in () }.takeUntil(rx.methodInvoked(#selector(viewWillDisappear(_:))))
            )
            .merge()
        /**
         *  初始化viewmodel
         */
        self.manageVm = Product_vm(
            input: (
                firstLoadTriger:firstLoadTriger,
                refreshTriger:  rx.sentMessage(#selector(Product_vc.headerRefresh)).map{_ in},
                loadMoreTriger: rx.sentMessage(#selector(Product_vc.footerRefresh)).map{_ in}
        ))
        self.manageVm?
            .productsElements
            .asObservable()
            .do(onNext: { [unowned self] (_) in
                self.errorPageView.isHidden = true
                self.showEmptyView = true
            })
            .bind(to: product_tv.rx.items(cellIdentifier: "Product_tCell", cellType: Product_tCell.self)) { (row, element, cell) in
                cell.item = element
            }
            .disposed(by: disposeBag)
        
        self.product_tv.rx
            .modelSelected(Product_model.self)
            .subscribe(onNext:  { item in
                _ = item.uri.openURL()
            })
            .disposed(by: disposeBag)
        
        self.product_tv.rx.setDelegate(self)
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
                    self.product_tv.mj_header.endRefreshing()
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
                    self.product_tv.mj_footer.endRefreshing()
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
                self.product_tv.mj_footer.endRefreshing()
            }).disposed(by: disposeBag)
        self.leftBtn.rx.tap.map{("scanvc",nil)}.bind(to: self.view.rx_openUrl).disposed(by: disposeBag)
        
        Observable.of(manageVm.error, manageVm.refresherror)
            .merge()
            .filter({ $0.code == 100010}) //100010token超时
            .subscribe(onNext: { (_) in
                _ = "login".openURL()
            }).disposed(by: disposeBag)
    }
    
    /**
     自定义leftBarButtonItem
     */
    override public func customLeftBarButtonItem()  {
        let leftItem = UIBarButtonItem(customView: self.leftBtn)
        self.navigationItem.leftBarButtonItem = leftItem
    }
}

// MARK: - 自定义方法
extension Product_vc {
    
    // 顶部刷新
    @objc func headerRefresh() {
        
    }
    
    @objc func footerRefresh() {
        
    }
}

// MARK: UITableViewDelegate
//extension Product_Vc :UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.productList.count
//    }
//
//}
//MARK: UITableViewDelegate
extension Product_vc: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 159
    }
}

/// 空数据数据代理
extension Product_vc :EmptyDataSource {
    func verticalOffset(emptyView scrollView: UIScrollView) -> CGFloat {
        return 0
    }
    func description(emptyView scrollView: UIScrollView) -> NSAttributedString?{
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
