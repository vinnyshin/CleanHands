//
//  StatisticViewController.swift
//  CleanHands
//
//  Created by ihavebrave on 2021/05/07.
//

import UIKit
import Charts

class StatisticViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBAction func changeChartPrev(_ sender: Any) {
        test()
    }
    
    @IBAction func changeChartNext(_ sender: Any) {
    }
    
    var allData = randomWashList
    var curChartDataSet : BarChartDataSet?
    var curChartData : BarChartData?// 실제로 차트 뷰에 넣는 데이터.
    
    var curNumWashinghands = [Int](repeating: 0, count: 7)
    
    
    //처음에 최근 1주일치 차트를 그린다.
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        
        setData(dataList: allData)
        chartConfigue()
    }
    
    func setData(dataList: [WashData]){
        //일별 손 씻은 횟수
         for i in 0..<7{
             curNumWashinghands[i] = dataList.filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
         }
        
        var dataEntries :[BarChartDataEntry] = []// 차트에 넣을 데이터(요일별 손 씻은 횟수)
        
         for i in 0..<curNumWashinghands.count {
             let dataEntry = BarChartDataEntry(x: Double(i), y: Double(curNumWashinghands[i]))
             dataEntries.append(dataEntry)
         }
         
         //2. 데이터엔트리와 라벨을 이용하여 데이터셋 만들기
        curChartDataSet = BarChartDataSet(entries: dataEntries)
        curChartDataSet!.highlightEnabled = false
        curChartDataSet!.colors = [.systemBlue]
        curChartData = BarChartData(dataSet: curChartDataSet)
    }
    
    func test(){
        var temp = allData
        temp.popLast()
        temp.popLast()
        temp.popLast()
        temp.popLast()
        setData(dataList: temp)
        chartConfigue()
        barChartView.data?.notifyDataChanged()
        barChartView.notifyDataSetChanged()
        print(temp.count)
        
    }
    
    
    private func chartConfigue(){
        barChartView.data = curChartData
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: DAY_OF_WEEK)
        barChartView.rightAxis.enabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.legend.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        
        //데이터 포인트에 생기는 세로선 제거하기
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.drawBordersEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled = false
    }
    
    
    
}
