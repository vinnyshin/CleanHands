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
    @IBOutlet weak var catchedPathoganNumLabel: UILabel!
    @IBOutlet weak var numCleanHandLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var textView: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    private var today = Date()
    private var state : ChartState?{
        didSet{
            makeChartData()
            barChartView.data = curChartData
            barChartView.data?.notifyDataChanged()
            barChartView.notifyDataSetChanged()
            
            setInfoLabels()
            setStateLabel()
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
        
//        initWashDataList(dataList: User.userState.washDataList)
//        initWashDataList(dataList: randomWashList)

        state = ChartState.CUR_WEEK
//        chartConfigue()
        graphView.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initWashDataList(dataList: User.userState.washDataList)
        chartConfigue()

        makeChartData()
        barChartView.data = curChartData
        barChartView.data?.notifyDataChanged()
        barChartView.notifyDataSetChanged()
        
        setInfoLabels()
        setStateLabel()
    }
    

    func initWashDataList(dataList: [WashData]){
        let m = criteriaFromWeekday(today: today)
        //1. 이번주, 지난주, 지지난주 데이터를 따로 리스트로 만들어준다.
        var tempWashDataLists : [[WashData]] = [[],[],[]]

        for washData in dataList {
            
            let diff = daysBetween(start: washData.date, end: today)
            let condition = (diff - m)
            
            print("오늘 :\(dateToDayOfWeek(date: today))")
            print("비교대상 요일 : \(dateToDayOfWeek(date: washData.date)), diff : \(diff), condition : \(condition)")
            if(condition <= 0){
                tempWashDataLists[ChartState.CUR_WEEK.rawValue].append(washData)
            }else if(condition <= 7){
                tempWashDataLists[ChartState.PREV_WEEK.rawValue].append(washData)
            }else if(condition <= 14){
                tempWashDataLists[ChartState.PPREV_WEEK.rawValue].append(washData)
            }
        }
        washDataLists = tempWashDataLists
            var tempNumWashLists = [[Int](repeating: 0, count: 7),[Int](repeating: 0, count: 7),[Int](repeating: 0, count: 7)]
        for i in 0..<7{
            tempNumWashLists[ChartState.CUR_WEEK.rawValue][i] = washDataLists[ChartState.CUR_WEEK.rawValue].filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
            tempNumWashLists[ChartState.PREV_WEEK.rawValue][i] = washDataLists[ChartState.PREV_WEEK.rawValue].filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
            tempNumWashLists[ChartState.PPREV_WEEK.rawValue][i] = washDataLists[ChartState.PPREV_WEEK.rawValue].filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
        }
        numWashLists = tempNumWashLists
 
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
        curChartDataSet.colors = [UIColor(red: 178/255, green: 211/255, blue: 227/255, alpha: 1)]
        curChartDataSet.valueFormatter = DigitValueFormatter()
        
        
        curChartData = BarChartData(dataSet: curChartDataSet)
    }
    
    private func setInfoLabels(){
        let numList = numWashLists[state!.rawValue]
        let washList = washDataLists[state!.rawValue]
        let sumNumWash = numList.reduce(0, {(s1: Int, s2: Int) -> Int in
            return s1 + s2
        })
        
        var avgNumWash : Int
        
        if (state == ChartState.CUR_WEEK){
            avgNumWash = sumNumWash / (criteriaFromWeekday(today: today) + 1)
        }else{
            avgNumWash = sumNumWash / numList.count
        }

        //catch한거 다 더하려면... 1. 워시데이터들로부터 딕셔너리 다 뽑아내기
        //워시 리스트로부터 딕셔너리 리스트를 뽑아왔다.
        let catchedDictList = washList.map({ (data: WashData) -> [Pathogen : Int] in
            return data.capturedPathogenDic
        })
        
        //딕셔너리 리스트에서
        var sumNumCatched = 0
        catchedDictList.forEach{
            //각 아이템은 딕셔너리다.
            let sumOfOneDictValue = $0.values.reduce(0, {(s1: Int, s2: Int) -> Int in
                return s1 + s2
            })
            sumNumCatched += sumOfOneDictValue
        }
        
        avgWashNumLabel.text = String(avgNumWash)
        catchedPathoganNumLabel.text = String(sumNumCatched)
        numCleanHandLabel.text = String(numList.reduce(0,{
            $0 + $1
        }))
        
        
    }
        
    private func setStateLabel(){
        if (state == ChartState.CUR_WEEK){
            stateLabel.text = "이번 주"
            nextButton.isEnabled = false
            prevButton.isEnabled = true
            prevButton.alpha = 1
            nextButton.alpha = 0
        }else if(state == ChartState.PREV_WEEK){
            stateLabel.text = "지난 주 통계"
            nextButton.isEnabled = true
            prevButton.isEnabled = true
            prevButton.alpha = 1
            nextButton.alpha = 1
        }else{
            stateLabel.text = "2주 전 통계"
            nextButton.isEnabled = true
            prevButton.isEnabled = false
            prevButton.alpha = 0
            nextButton.alpha = 1
        }
            
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
        
        barChartView.leftAxis.axisMinimum = 0
        barChartView.leftAxis.valueFormatter = DigitValueFormatter() as! IAxisValueFormatter
    }
    
    
    
}
