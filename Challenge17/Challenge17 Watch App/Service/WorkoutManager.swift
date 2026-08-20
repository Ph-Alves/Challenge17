//
//  HealthKit+WorkoutManager.swift
//  Challenge17
//
//  Created by Lucas Vasconcellos Côrtes on 8/18/26.
//

import HealthKit
import Observation

struct WorkoutResult {
    let duration: TimeInterval
    let calories: Double
    let heartRate: Double
}

protocol WorkoutManagerProtocol: AnyObject {
    var workoutResult: WorkoutResult? { get }
    
    func askHealthPermission()
    
    func startWorkout()
    func stopWorkout()
}


final class WorkoutManager: NSObject, WorkoutManagerProtocol, HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: any Error) {
    
    }
    
    private(set) var workoutResult: WorkoutResult?
    private(set) var currentHeartRate: Double = 0
    private(set) var currentCalories: Double = 0
    
    private let healthStore = HKHealthStore()
    
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?
    
    func returnResult() -> WorkoutResult? {
        workoutResult
    }
    
    func askHealthPermission() {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }

        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate),
              let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }

        let workoutType = HKObjectType.workoutType()

        let typesToShare: Set<HKSampleType> = [
            workoutType
        ]

        let typesToRead: Set<HKObjectType> = [
            heartRateType,
            activeEnergyType
        ]

        healthStore.requestAuthorization(
            toShare: typesToShare,
            read: typesToRead
        ) { success, error in
            if let error {
                print("HealthKit authorization failed:", error)
                return
            }

            print("HealthKit authorization:", success)
        }
    }
    
    func startWorkout() {
        workoutResult = nil
        
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .mixedCardio
        configuration.locationType = .unknown
        
        do {
            let session = try HKWorkoutSession(
                healthStore: healthStore,
                configuration: configuration)
            session.delegate = self
            
            let builder = session.associatedWorkoutBuilder()
            builder.delegate = self
            
            workoutSession = session
            workoutBuilder = builder
            
            let startDate = Date()
            
            session.startActivity(with: startDate)
            
            builder.dataSource = HKLiveWorkoutDataSource(
                healthStore: healthStore,
                workoutConfiguration: configuration
            )
            
            builder.beginCollection(withStart: startDate) { [weak self] success, error in
                guard let self else { return }

                if let error {
                    print("Failed to start workout collection:", error)
                    self.workoutSession?.end()
                    self.workoutSession = nil
                    self.workoutBuilder = nil
                    return
                }

                guard success else {
                    print("Workout collection returned false")
                    return
                }

                print("Workout started: true")
            }
            
        } catch {
            print("Failed to create workout session:", error)
        }
    }
    
    func stopWorkout() {
        workoutSession?.end()
        print("Workout stopped")
    }
}

extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        
    }
    
    func workoutBuilder(
        _ workoutBuilder: HKLiveWorkoutBuilder,
        didCollectDataOf collectedTypes: Set<HKSampleType>
    ) {
        print("📡 didCollectDataOf chamado")

        for type in collectedTypes {
            print("📊 Tipo recebido:", type.identifier)
        }

        guard
            let heartRateType = HKQuantityType.quantityType(
                forIdentifier: .heartRate
            ),
            let activeEnergyType = HKQuantityType.quantityType(
                forIdentifier: .activeEnergyBurned
            )
        else {
            return
        }

        if collectedTypes.contains(heartRateType) {
            print("❤️ Heart Rate recebido")

            if let statistics = workoutBuilder.statistics(for: heartRateType),
               let quantity = statistics.mostRecentQuantity() {

                let heartRate = quantity.doubleValue(
                    for: HKUnit.count().unitDivided(by: .minute())
                )

                currentHeartRate = heartRate

                print("❤️ HR:", heartRate)
            }
        }

        if collectedTypes.contains(activeEnergyType) {
            print("🔥 Active Energy recebido")

            if let statistics = workoutBuilder.statistics(for: activeEnergyType),
               let quantity = statistics.sumQuantity() {

                let calories = quantity.doubleValue(
                    for: .kilocalorie()
                )

                currentCalories = calories

                print("🔥 Calories:", calories)
            }
        }
    }
    

    @objc(workoutSession:didChangeToState:fromState:date:) func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        
        guard toState == .ended else { return }
        
        workoutBuilder?.endCollection(withEnd: date) { [weak self] _, error in

            guard let self else { return }
            
            if let error {
                print(error)
                return
            }

            self.workoutBuilder?.finishWorkout { workout, error in
                if let error {
                    print(error)
                    return
                }

                guard let workout else { return }

                print("Duration:", workout.duration)

                guard let activeEnergyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
                
                let duration = workout.duration
                
                let calories = workout.statistics(for: activeEnergyType)?
                    .sumQuantity()?
                    .doubleValue(for: .kilocalorie()) ?? 0
                
                print("Calories: \(calories)")

                guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
                    return
                }

                let heartRate = workout.statistics(for: heartRateType)?
                    .averageQuantity()?
                    .doubleValue(for: HKUnit.count().unitDivided(by: .minute())) ?? 0
                
                DispatchQueue.main.async {
                    self.workoutResult = WorkoutResult(duration: duration, calories: calories, heartRate: heartRate)
                }
            }

        }

    }
}

