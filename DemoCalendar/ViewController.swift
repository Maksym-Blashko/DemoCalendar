//
//  ViewController.swift
//  DemoCalendar
//
//  Created by Maksym Blashko on 07.10.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var startSelectedDate: DateComponents?
    private var endSelectedDate: DateComponents?
    
    private var calendarView: UICalendarView?
    private var tintColor: UIColor = .blue
    private var selectionColor: UIColor = .cyan

    @IBAction func resetTapped(_ sender: Any) {
        startSelectedDate = nil
        endSelectedDate = nil
        let calendarSelection = calendarView?.selectionBehavior as? UICalendarSelectionMultiDate
        calendarSelection?.setSelectedDates([], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendar()
    }

    private func setupCalendar() {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        calendarView.availableDateRange = DateInterval.init(start: Date.now, end: Date.distantFuture)

        let multiDateSelection = UICalendarSelectionMultiDate(delegate: self)
        calendarView.selectionBehavior = multiDateSelection
        
        calendarView.tintColor = tintColor
        
        self.calendarView = calendarView
    }

}

extension ViewController: UICalendarSelectionMultiDateDelegate {
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        if startSelectedDate != nil, endSelectedDate != nil {
            //should select start date
            selectStartDate(dateComponents, selection: selection)
            
        } else if let startDate = startSelectedDate {
            if startDate <= dateComponents {
                //should select range
                selection.setSelectedDates([], animated: true)
                endSelectedDate = dateComponents
                
                selection.setSelectedDates(startDate.getDateComponentsArrayTill(dateComponents), animated: true)
            } else {
                //should select start date
                selectStartDate(dateComponents, selection: selection)
            }
        } else {
            //it's selection of the start date
            startSelectedDate = dateComponents
            endSelectedDate = nil
        }
        
        customizeSelection(with: selectionColor, for: calendarView)
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        if startSelectedDate != nil, endSelectedDate != nil {
            //should select start date
            selectStartDate(dateComponents, selection: selection)
        }
        customizeSelection(with: selectionColor, for: calendarView)
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canSelectDate dateComponents: DateComponents) -> Bool {
        customizeSelection(with: selectionColor, for: calendarView)
        return true
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canDeselectDate dateComponents: DateComponents) -> Bool {
        customizeSelection(with: selectionColor, for: calendarView)
        return startSelectedDate != nil && endSelectedDate != nil
    }
    
    private func selectStartDate(_ dateComponents: DateComponents, selection: UICalendarSelectionMultiDate) {
        selection.setSelectedDates([], animated: true)
        startSelectedDate = dateComponents
        endSelectedDate = nil
        selection.setSelectedDates([dateComponents], animated: true)
    }
}

extension ViewController {
    func customizeSelection(with color: UIColor, for calendarView: UICalendarView?) {
        guard let calendarView = calendarView else { return }
        guard let indexPathsForSelectedItems = (calendarView.subviews.first?.subviews.first(where: { $0 is UICollectionView }) as? UICollectionView)?.indexPathsForSelectedItems else { return }
        
        indexPathsForSelectedItems.forEach({ indexPath in
            let cell = (calendarView.subviews.first?.subviews.first(where: { $0 is UICollectionView }) as? UICollectionView)?.cellForItem(at: indexPath)

            let selectionLayer = cell?.subviews.first?.subviews.first?.layer.sublayers?.first
            
            selectionLayer?.backgroundColor = color.cgColor // to apply custom selection color
            selectionLayer?.maskedCorners = CACornerMask() // to make squares instead of circles
        })
    }
}
