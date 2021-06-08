//
//  StatisticViewController.swift
//  CleanHands
//
//  Created by ihavebrave on 2021/05/07.
//

import UIKit
import Charts

class StatisticViewController: UIViewController {
    private enum ChartState : Int{
        case PPREV_WEEK
        case PREV_WEEK
        case CUR_WEEK
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
    
    var washDataLists : [[WashData]] = [[],[],[]]
    var numWashLists = [[Int](repeating: 0, count: 7),[Int](repeating: 0, count: 7),[Int](repeating: 0, count: 7)]
    
    @IBAction func changeChartNext(_ sender: Any) {
        if(state == ChartState.CUR_WEEK){
            return
        }
        if(state == ChartState.PREV_WEEK){
            state = ChartState.CUR_WEEK
        }else if (state == ChartState.PPREV_WEEK){
            state = ChartState.PREV_WEEK
        }
    }
    
    @IBAction func changeChartPrev(_ sender: Any) {
        if(state == ChartState.PPREV_WEEK){
            return
        }
        if(state == ChartState.CUR_WEEK){
            state = ChartState.PREV_WEEK
        }else if (state == ChartState.PREV_WEEK){
            state = ChartState.PPREV_WEEK
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        initWashDataList(dataList: randomWashList)
        state = ChartState.CUR_WEEK
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
                washDataLists[ChartState.CUR_WEEK.rawValue].append(washData)
            }else if(condition <= 7){
                washDataLists[ChartState.PREV_WEEK.rawValue].append(washData)
            }else if(condition <= 14){
                washDataLists[ChartState.PPREV_WEEK.rawValue].append(washData)
            }
        }
        for i in 0..<7{
            numWashLists[ChartState.CUR_WEEK.rawValue][i] = washDataLists[ChartState.CUR_WEEK.rawValue].filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
            numWashLists[ChartState.PREV_WEEK.rawValue][i] = washDataLists[ChartState.PREV_WEEK.rawValue].filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
            numWashLists[ChartState.PPREV_WEEK.rawValue][i] = washDataLists[ChartState.PPREV_WEEK.rawValue].filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
        }
 
    }
    
    func makeChartData(){
        var numList: [Int]
        if (state == ChartState.CUR_WEEK){
            numList = numWashLists[ChartState.CUR_WEEK.rawValue]
        }else if (state == ChartState.PREV_WEEK){
            numList = numWashLists[ChartState.PREV_WEEK.rawValue]
        }else{
            numList = numWashLists[ChartState.PPREV_WEEK.rawValue]
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
//        @IBOutlet weak var NumCleanHandLabel:
//        var avgWashNum =
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
