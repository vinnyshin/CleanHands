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
    
    
    var unitsSold: [Double]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        
        initChart()
    }
    
    //차트에 최근 7일 요일별 손씻기 횟수를 넣습니다.
    func initChart() {
        //1. 최근 7일 데이터를 가져온다
        //2. 요일별로 카운팅한다.
        var numWashingHands = [Int](repeating: 0, count: 7)
        for i in 0..<7{
            numWashingHands[i] = dummyWashDataList.filter{ dateToDayOfWeek(date: $0.date) == DAY_OF_WEEK[i]}.count
        }
        //3. 주당 몇회인지 차트에 넣는다.
        
        
        
        //1. 데이터 엔트리에 초기화
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<numWashingHands.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(numWashingHands[i]))
            dataEntries.append(dataEntry)
        }
        //2. 데이터엔트리와 라벨을 이용하여 데이터셋 만들기
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        chartDataSet.highlightEnabled = false
        chartDataSet.colors = [.systemBlue]
        

        // 데이터셋으로 데이터를 만들고, 차트뷰에 넣어주기.
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        chartConfigue()
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
