//
//  ViewController.swift
//  Stopwatch
//
//  Created by Pedro Fernandez on 12/13/21.
//

import UIKit

class StopwatchViewController: UIViewController {
    // MARK: Variables
    private var mainStopwatch: Stopwatch = Stopwatch()
    private var lapStopwatch: Stopwatch = Stopwatch()
    private var laps = [Lap]()
    private let buttonSize = 89.0

    // MARK: UI Components
    private var timerLabel: UILabel = {
        let label = UILabel()
        label.text = Stopwatch.defaultTime
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 90, weight: UIFont.Weight.regular)
        label.font = UIFont(name: "Avenir-Light", size: 90)

        return label
    }()
    
    private lazy var lapResetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Lap", for: .normal)
        button.setTitle("Reset", for: .selected)
        button.setTitleColor(AppConstants.Colors.gray, for: .normal)
        button.setBackgroundColor(AppConstants.Colors.grayDisabled, for: .disabled)
        button.setBackgroundColor(AppConstants.Colors.grayEnabled, for: .normal)
        button.layer.cornerRadius = self.buttonSize/2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(lapResetButtonTarget(_:)), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var startStopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitle("Stop", for: .selected)
        button.setTitleColor(.green, for: .normal)
        button.setTitleColor(.red, for: .selected)
        button.setBackgroundColor(AppConstants.Colors.green, for: .normal)
        button.setBackgroundColor(AppConstants.Colors.red, for: .selected)
        button.layer.cornerRadius = self.buttonSize/2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(startStopButtonTarget(_:)), for: .touchUpInside)
        return button
    }()
    
    private var lapsTableView: UITableView = {
        let tableView = UITableView()
        tableView.fillerRowHeight = 1.0
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LapTableViewCell.self, forCellReuseIdentifier: "LapViewCell")
        return tableView
    }()
    private let tableViewData = Array(repeating: "Item", count: 20)
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        overrideUserInterfaceStyle = .dark
        
        lapsTableView.dataSource = self
        lapsTableView.estimatedRowHeight = 50
        mainStopwatch.delegate = self
        setupConstraints()
    }
    
    private func setupConstraints() {
        // AutoLayout timer label
        view.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 195.0),
            timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0)
        ])
        
        // Create buttons stack
        let buttonsStackView = UIStackView(arrangedSubviews: [lapResetButton, startStopButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .equalSpacing
        buttonsStackView.alignment = .center
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // AutoLayout stackview
        view.addSubview(buttonsStackView)
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 110.0),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0)
        ])
        
        // AutoLayout buttons
        NSLayoutConstraint.activate([
            lapResetButton.heightAnchor.constraint(equalToConstant: buttonSize),
            lapResetButton.widthAnchor.constraint(equalToConstant: buttonSize),
            startStopButton.heightAnchor.constraint(equalToConstant: buttonSize),
            startStopButton.widthAnchor.constraint(equalToConstant: buttonSize)
        ])
        
        // AutoLayout tableview
        view.addSubview(lapsTableView)
        NSLayoutConstraint.activate([
            lapsTableView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 10.0),
            lapsTableView.leadingAnchor.constraint(equalTo: buttonsStackView.leadingAnchor, constant: 0.0),
            lapsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            lapsTableView.trailingAnchor.constraint(equalTo: buttonsStackView.trailingAnchor, constant: 0.0)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        drawCircleInsideButton(lapResetButton)
        drawCircleInsideButton(startStopButton)
    }
    
    private func drawCircleInsideButton(_ button: UIButton) {
        let center = CGPoint(x: button.bounds.midX, y: button.bounds.midY)
        let circularPath = UIBezierPath(arcCenter: center, radius: 40, startAngle: 0,
                                        endAngle: 2.0 * CGFloat.pi, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.position = button.center
        shapeLayer.frame = button.bounds
        button.layer.addSublayer(shapeLayer)
    }
    
    @objc func lapResetButtonTarget(_ sender: UIButton!) {
        switch mainStopwatch.mode {
        case .paused:
            resetTimer()
        case .running:
            let lapTitle = "Lap " + String(laps.count + 1)
            let lapElapsedTime = lapStopwatch.getElapsedTime()
            
            laps[laps.count-1].lapTime = lapElapsedTime
            laps.append(Lap(title: lapTitle, lapTime: lapElapsedTime))
            lapsTableView.reloadData()
            lapStopwatch.restart()
        case .stopped:
            break
        }
    }
    
    @objc func startStopButtonTarget(_ sender: UIButton!) {
        switch mainStopwatch.mode {
        case .paused:
            mainStopwatch.start()
            lapStopwatch.start()
            startStopButton.isSelected = true
            lapResetButton.isSelected = false
        case .stopped:
            if laps.isEmpty {
                laps.append(Lap(title: "Lap 1", lapTime: Stopwatch.defaultTime))
                lapsTableView.reloadData()
            }
            
            mainStopwatch.start()
            lapStopwatch.start()
            startStopButton.isSelected = true
            lapResetButton.isEnabled = true
            lapResetButton.isSelected = false
        case .running:
            mainStopwatch.pause()
            lapStopwatch.pause()
            startStopButton.isSelected = false
            lapResetButton.isSelected = true
        }
    }
    
    func resetTimer() {
        // Reset UI
        timerLabel.text = "00:00.00"
        lapResetButton.isEnabled = false
        
        // Reset stopwatches
        mainStopwatch.reset()
        lapStopwatch.reset()
        
        // Reset laps and tableview
        laps.removeAll()
        lapsTableView.reloadData()
    }
}

extension StopwatchViewController: UITableViewDataSource, StopwatchDelegate {
    static let lapCellIdentifier = "LapViewCell"
    
    func stopwatchFired(_ stopwatch: Stopwatch, elapsedTime: String) {
        timerLabel.text = elapsedTime
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.lapCellIdentifier, for: indexPath)
        
        if indexPath.row == 0 {
            lapStopwatch.delegate = cell as? StopwatchDelegate
        }
        
        cell.textLabel?.text = laps[laps.count - indexPath.row - 1].title
        cell.textLabel?.textColor = .label
        cell.detailTextLabel?.text = laps[laps.count - indexPath.row - 1].lapTime
        cell.detailTextLabel?.textColor = .label
        cell.backgroundColor = .systemBackground
        return cell
    }
}
