//
//  ViewController.swift
//  xinhao
//
//  Created by dzc on 2021/3/17.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //信号量控制线程并发，锁
        //DispatchSemaphore 因为信号量值为1，所以一次只能执行一个
         let semaphore = DispatchSemaphore(value: 1)
         let queue = DispatchQueue.global()
         queue.async {
             semaphore.wait()
             let deadline = DispatchTime.now() + 3.0
             DispatchQueue.global().asyncAfter(deadline: deadline) {
                 print("-----------------1");
                 semaphore.signal()
             }
              
         }

         queue.async {
             semaphore.wait()
             let deadline = DispatchTime.now() + 10.0
             DispatchQueue.global().asyncAfter(deadline: deadline) {
                  print("-----------------2");
                  semaphore.signal()
             }
              
         }
         queue.async {
             semaphore.wait()
             let deadline = DispatchTime.now() + 2.0
             DispatchQueue.global().asyncAfter(deadline: deadline) {
                 print("-----------------3");
                 semaphore.signal()
             }
              
         }
        
        /////gropu enter和leave配合
        // 创建调度组
        let workingGroup = DispatchGroup()
        // 创建队列
        let workingQueue = DispatchQueue(label: "request_queue")
         
        // 模拟异步发送网络请求 A
        // 入组
        workingGroup.enter()
        workingQueue.async {
            Thread.sleep(forTimeInterval: 1)
            print("接口 A 数据请求完成")
            // 出组
            workingGroup.leave()
        }
         
        // 模拟异步发送网络请求 B
        // 入组
        workingGroup.enter()
        workingQueue.async {
            Thread.sleep(forTimeInterval: 1)
            print("接口 B 数据请求完成")
            // 出组
            workingGroup.leave()
        }
         
        print("我是最开始执行的，异步操作里的打印后执行")
         
        // 调度组里的任务都执行完毕
        workingGroup.notify(queue: workingQueue) {
            print("接口 A 和接口 B 的数据请求都已经完毕！, 开始合并两个接口的数据")
        }
        
        
    }


}

