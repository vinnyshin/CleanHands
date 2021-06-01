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
    
    var days: [String]!
    var unitsSold: [Double]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        days = ["월", "화", "수", "목", "금", "토", "일"]
        
        unitsSold = [1,2,3,4,5,6,7]
        
        barChartView.noDataText = "데이터가 없습니다."
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        
        setChart(dataPoints: days, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        //1. 데이터 엔트리에 초기화
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        //2. 데이터엔트리와 라벨을 이용하여 데이터셋 만들기
        let chartDataSet = BarChartDataSet(entries: dataEntries)
        chartDataSet.highlightEnabled = false
        chartDataSet.colors = [.systemBlue]
        

        // 데이터셋으로 데이터를 만들고, 차트뷰에 넣어주기.
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        barChartView.rightAxis.enabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.legend.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        
        //데이터 포인트에 생기는 세로선 제거하기
        barChartView.xAxis.drawGridLinesEnabled = false
        
        barChartView.drawBordersEnabled = false
        barChartView.leftAxis.drawAxisLineEnabled = false
        
        
//        barChartView.xAxis.drawAxisLineEnabled = false
//
        
//        barChartView.rightAxis.drawAxisLineEnabled = false
//        barChartView.drawGridBackgroundEnabled = false
        

        
    }
    
}
