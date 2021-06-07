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
    
    private var today = Date()
    
    var curChartDataSet : BarChartDataSet?
    var curChartData : BarChartData?// 실제로 차트 뷰에 넣는 데이터.
    
    var curWashDataList :[WashData] = []
    var prevWashDataList :[WashData] = []
    var pprevWashDataList :[WashData] = []
    
    var curNumWashingHands = [Int](repeating: 0, count: 7)
    var prevNumWashingHands = [Int](repeating: 0, count: 7)
    var pprevNumWashingHands = [Int](repeating: 0, count: 7)
    
    
    //처음에 최근 1주일치 차트를 그린다.
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        initWashDataList(dataList: randomWashList)
        makeChartData(selectednumList: curNumWashingHands)
        chartConfigue()
    }
    
    func initWashDataList(dataList: [WashData]){
        let m = criteriaFromWeekday(today: today)
        //1. 이번주, 지난주, 지지난주 데이터를 따로 리스트로 만들어준다.
        for washData in dataList {
            
            
            let diff = daysBetween(start: washData.date, end: today)
            let condition = (diff - m)
            
            
            
            print("오늘 :\(dateToDayOfWeek(date: today))")
            print("비교대상 요일 : \(dateToDayOfWeek(date: washData.date)), diff : \(diff), condition : \(condition)")
            
            
            if(condition <= 0){
                curWashDataList.append(washData)
            }else if(condition <= 7){
                prevWashDataList.append(washData)
            }else if(condition <= 14){
                pprevWashDataList.append(washData)
            }
        }
        for i in 0..<7{
            curNumWashingHands[i] = curWashDataList.filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
        }
        
        for i in 0..<7{
            prevNumWashingHands[i] = prevWashDataList.filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
        }
        
        for i in 0..<7{
            pprevNumWashingHands[i] = pprevWashDataList.filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
        }
 
    }
    
    func makeChartData(selectednumList: [Int]){
        
        var dataEntries :[BarChartDataEntry] = []// 차트에 넣을 데이터(요일별 손 씻은 횟수)
        
        for i in 0..<selectednumList.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(selectednumList[i]))
            dataEntries.append(dataEntry)
         }
         
         //2. 데이터엔트리와 라벨을 이용하여 데이터셋 만들기
        curChartDataSet = BarChartDataSet(entries: dataEntries)
        curChartDataSet!.highlightEnabled = false
        curChartDataSet!.colors = [.systemBlue]
        curChartData = BarChartData(dataSet: curChartDataSet)
    }
    
    
    func test(){
        makeChartData(selectednumList: prevNumWashingHands)
        chartConfigue()
        barChartView.data?.notifyDataChanged()
        barChartView.notifyDataSetChanged()
        
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
