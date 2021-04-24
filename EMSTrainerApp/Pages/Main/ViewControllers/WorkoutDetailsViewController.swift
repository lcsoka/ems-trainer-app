//
//  WorkoutDetailsViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 24..
//

import UIKit
import Charts
class WorkoutDetailsViewController: UIViewController, MainStoryboardLodable {
    
    @IBOutlet var lblWorkoutType: UILabel!
    @IBOutlet var workoutImage: UIImageView!
    @IBOutlet var lblWorkoutInterval: UILabel!
    @IBOutlet var lblWorkoutLength: UILabel!
    
    @IBOutlet var lineChartView: LineChartView!
    
    var viewModel: WorkoutDetailsViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupChart()
    }
    
    func setupUI() {
        let workout = viewModel.workout!
        let date = workout.date!
        let titleFormatter = DateFormatter()
        titleFormatter.dateStyle = .long
        title = titleFormatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let startDate = Calendar.current.date(byAdding: .second, value: -Int(workout.length), to: date)
        
        let start = timeFormatter.string(from: startDate!)
        let end = timeFormatter.string(from: date)
        
        lblWorkoutInterval.text = "\(start) - \(end)"
        lblWorkoutType.text = "\(workout.trainingMode!.capitalized) Workout"
        lblWorkoutLength.text = Converter.getTimeStrWithHour(Int(workout.length))
        
        if let image = UIImage(named: workout.trainingMode!) {
            workoutImage.image = image
        }
        
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
    func setupChart() {
        lineChartView.delegate = self
        
        // Customizations here
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.valueFormatter = TimestampFormatter()
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        leftAxis.drawGridLinesEnabled = false
        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 100
        leftAxis.yOffset = -10
        leftAxis.labelTextColor = .white
        leftAxis.drawBottomYLabelEntryEnabled = true
        leftAxis.spaceTop = 10.0
        
        lineChartView.setViewPortOffsets(left: 30, top: 20, right: 20, bottom: 20)
        lineChartView.rightAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.animate(yAxisDuration: 1)
        
        // Generate entries
        let values = viewModel.trainingValues.map { (i)-> ChartDataEntry in
            let val = Double(i.master)
            let timestamp = Double(i.timestamp)
            return ChartDataEntry(x: timestamp, y: val)
        }
        
        let set = LineChartDataSet(entries: values, label: "Workout Data")
        // TODO: Customize set
        set.mode = .horizontalBezier
        set.drawCirclesEnabled = true
        set.circleColors = [UIColor.init(named: "Green300")!]
        set.setColor(UIColor.init(named: "Green500")!)
        set.lineWidth = 1.8
        set.circleRadius = 3
        set.drawCircleHoleEnabled = false
        set.valueFont = .systemFont(ofSize: 9)
        set.formLineDashLengths = [5, 2.5]
        set.formLineWidth = 1
        set.formSize = 15
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawVerticalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSet: set)
        data.setValueTextColor(UIColor.init(named: "Green300")!)
        data.setValueFormatter(ValueFormatter())
        lineChartView.data = data
    }
    
}

class TimestampFormatter: NSObject, IAxisValueFormatter {
    override init() {
        super.init()
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return Converter.secondsToTimeString(Int(value))
    }
}

class ValueFormatter: NSObject, IValueFormatter {
    public func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return "\(Int(value))"
    }
}

extension WorkoutDetailsViewController: ChartViewDelegate {
    
}
