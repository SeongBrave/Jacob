//
//  Product_vm.swift
//  Jacob
//
//  Created by Gckit on 2019/04/07.
//  Copyright (c) 2019 SeongBrave. All rights reserved.
//

import RxSwift
import NetWorkCore
import SwiftyJSON
import UtilCore
import Result


class Product_vm : BaseList_Vm{
    /// 表示正在刷新中
    let loading = ActivityIndicator()
    /// 表示在下来刷新中
    let pullLoading = ActivityIndicator()
    /*
     接收返回的数据
     */
    /// 返回首页数据
    let productsElements = Variable<[Product_model]>([])
    /// 表示正在刷新中
    let refreshing = Variable(false)
    
    init(input: (
        firstLoadTriger: Observable<Void>,
        refreshTriger: Observable<Void>,
        loadMoreTriger: Observable<Void>
        )) {
        super.init()
        /// 界面第一次初始化
        let _ =  Observable.of(
            input.firstLoadTriger,
            reloadTrigger.withLatestFrom(input.firstLoadTriger))
            .merge().map{ Product_api.products(page: 0, pageSize: 10)}.share(replay: 1)
            .emeRequestApiForArray(Product_model.self,activityIndicator: loading)
            .subscribe(onNext: {[unowned self] (result) in
                switch result {
                case .success(let data):
                    self.hasNextPage.value = data.count == 10
                    self.productsElements.value = data.filter({ (item) -> Bool in
                        item.desc.length > 0
                    })
                    self.page = 1
                case .failure(let error):
                    self.refresherror.onNext(error)
                }
            })
            .disposed(by: disposeBag)
        
        /// 下拉刷新事件源
        input.refreshTriger
            .map{ Product_api.products(page: 0, pageSize: 10)}
            .emeRequestApiForArray(Product_model.self,activityIndicator: pullLoading)
            .subscribe(onNext: {[unowned self] (result) in
                switch result {
                case .success(let data):
                    /**
                     *  如果返回的数据正好相同 则默认还有数据
                     */
                    self.hasNextPage.value = data.count == 10
                    self.productsElements.value = data.filter({ (item) -> Bool in
                        item.desc.length > 0
                    })
                    self.page = 1
                case .failure(let error):
                    self.refresherror.onNext(error)
                }
            })
            .disposed(by: disposeBag)
        
        input.loadMoreTriger
            .map{ Product_api.products(page: self.page, pageSize: 10)}
            .emeRequestApiForArray(Product_model.self)
            .subscribe(onNext: {[unowned self] (result) in
                switch result {
                case .success(let data):
                    /**
                     *  如果返回的数据正好相同 则默认还有数据
                     */
                    self.hasNextPage.value = data.count == 10
                    self.productsElements.value  = self.productsElements.value + data.filter({ (item) -> Bool in
                        item.desc.length > 0
                    })
                    /**
                     *  需要修改page 页数
                     */
                    self.page = self.page +  1
                    
                case .failure(let error):
                    self.error.onNext(error)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
