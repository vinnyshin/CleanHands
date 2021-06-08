//
//  StatisticViewController.swift
//  CleanHands
//
//  Created by ihavebrave on 2021/05/07.
//

import UIKit
import Charts

class StatisticViewController: UIViewController {
    private enum ChartState {
        case PPrev
        case Prev
        case Cur
    }
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var avgWashNumLabel: UILabel!
    @IBOutlet weak var CatchedPathoganNumLabel: UILabel!
    @IBOutlet weak var NumCleanHandLabel: UILabel!
    
    private var today = Date()
    private var state : ChartState?{
        didSet{
            makeChartData()
            barChartView.data = curChartData
            barChartView.data?.notifyDataChanged()
            barChartView.notifyDataSetChanged()
        }
    }
    
    
    var curChartData : BarChartData?// 실제로 차트 뷰에 넣는 데이터.
    
    var curWeekWashDataList :[WashData] = []
    var prevWeekWashDataList :[WashData] = []
    var pprevWeekWashDataList :[WashData] = []
    
    var curWeekNumWashingHands = [Int](repeating: 0, count: 7)
    var prevWeekNumWashingHands = [Int](repeating: 0, count: 7)
    var pprevWeekNumWashingHands = [Int](repeating: 0, count: 7)
    
    @IBAction func changeChartNext(_ sender: Any) {
        if(state == ChartState.Cur){
            return
        }
        if(state == ChartState.Prev){
            state = ChartState.Cur
        }else if (state == ChartState.PPrev){
            state = ChartState.Prev
        }
    }
    
    @IBAction func changeChartPrev(_ sender: Any) {
        if(state == ChartState.PPrev){
            return
        }
        if(state == ChartState.Cur){
            state = ChartState.Prev
        }else if (state == ChartState.Prev){
            state = ChartState.PPrev
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        initWashDataList(dataList: randomWashList)
        state = ChartState.Cur
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
                curWeekWashDataList.append(washData)
            }else if(condition <= 7){
                prevWeekWashDataList.append(washData)
            }else if(condition <= 14){
                pprevWeekWashDataList.append(washData)
            }
        }
        for i in 0..<7{
            curWeekNumWashingHands[i] = curWeekWashDataList.filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
        }
        for i in 0..<7{
            prevWeekNumWashingHands[i] = prevWeekWashDataList.filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
        }
        for i in 0..<7{
            pprevWeekNumWashingHands[i] = pprevWeekWashDataList.filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
        }
 
    }
    
    func makeChartData(){
        var numList: [Int]
        if (state == ChartState.Cur){
            numList = curWeekNumWashingHands
        }else if (state == ChartState.Prev){
            numList = prevWeekNumWashingHands
        }else{
            numList = pprevWeekNumWashingHands
        }
        var dataEntries :[BarChartDataEntry] = []// 차트에 넣을 데이터(요일별 손 씻은 횟수)
        
        for i in 0..<numList.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(numList[i]))
            dataEntries.append(dataEntry)
         }
         
        //2. 데이터엔트리와 라벨을 이용하여 데이터셋 만들기
        let curChartDataSet = BarChartDataSet(entries: dataEntries)
        curChartDataSet.highlightEnabled = false
        curChartDataSet.colors = [.systemBlue]
        curChartData = BarChartData(dataSet: curChartDataSet)
    }
    
    func setInfoLabels(){
//        @IBOutlet weak var avgWashNumLabel:
//        @IBOutlet weak var CatchedPathoganNumLabel: UILabel!
//        @IBOutlet weak var NumCleanHandLabel: UILabel!
        
//        avgWashNumLabel.text =
    }
    
    
    
    
    private func chartConfigue(){
        
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
