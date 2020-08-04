//
//  LeagueApi.swift
//  Legend Within
//
//  Created by Balazs Erdesz on 2020. 06. 29..
//  Copyright © 2020. EBUniApps. All rights reserved.
//

import Foundation
import Moya
import Combine

public class LeagueApi : ObservableObject {
    private(set) static var shared = LeagueApi()
    private init() {
        self.setupUpdateCycleSubscription()
    }

    @Published var newVersionExists: Bool? = nil
    @Published var updateProgress = UpdateProgress()
    private var versionToDownload: String? = nil
    private var cancellableBag = Set<AnyCancellable>()
    private let bagSafetyQueue = DispatchQueue(label: "leagueApi.bagSafetyQueue", qos: .userInteractive)

    private let ddProvider = MoyaProvider<DataDragon>()

    //MARK:- Static members
    class func apiUrl(region: Region) -> URL {
        URL(string: String("https://\(region.urlPrefix).api.riotgames.com"))!
    }

    static let commonHeaders: [String : String]? = [
        "X-Riot-Token" : LeagueApi.key
    ]

    //MARK: - Update cycle
    private func setupUpdateCycleSubscription() {
        $newVersionExists
            .sink { [weak self] exists in
                guard exists != nil && exists! else { return }
                self?.beginUpdateData()
            }
            .store(in: &cancellableBag)

        Publishers.CombineLatest3(updateProgress.$championsJSONProgress,
                                  updateProgress.$itemsJSONProgress,
                                  updateProgress.$championUniqueJSONsProgress)
            .sink { [weak self] progress in
                guard let self = self else { return }

                if self.updateProgress.willFinishWithValues(championsProgress: progress.0,
                                                            itemsProgress: progress.1,
                                                            uniqueChampionsProgress: progress.2) {
                    UserDefaults.standard.set(self.versionToDownload, forKey: Settings.currentDownloadedVersion)
                    self.updateProgress = UpdateProgress()
                    self.versionToDownload = nil
                    self.newVersionExists = false
                }
            }
            .store(in: &cancellableBag)

        updateProgress.$championsJSONProgress
            .sink { [weak self] progress in
                if progress.isEqual(to: 1.0) {
                    self?.updateUniqueChampionJSONs()
                }
            }
            .store(in: &cancellableBag)
    }

    func checkForUpdates() {
        var cancellable: AnyCancellable?
        cancellable = self.ddProvider.requestPublisher(.versions)
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .sink(receiveCompletion: { completionType in
                print(completionType)
            }, receiveValue: { [weak self] response in
                print(response)

                let versions = try! response.map([String].self)
                let latestVersion = versions.first!

                let newerExists = latestVersion != UserDefaults.standard.string(forKey: Settings.currentDownloadedVersion)
                if newerExists {
                    guard let self = self else { return }

                    self.versionToDownload = latestVersion

                    DispatchQueue.main.async {
                        self.newVersionExists = true
                    }
                } else {
                    self?.newVersionExists = false
                }

                self?.cancellableBag.remove(cancellable!)
            })

        self.cancellableBag.insert(cancellable!)
    }

    func beginUpdateData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let championsPath = documentsDirectory.appendingPathComponent("champion.json")
        let itemsPath = documentsDirectory.appendingPathComponent("item.json")

        self.downloadJson(targetType: .champions(downloadPath: championsPath), progressRatio: 1.0)
        self.downloadJson(targetType: .items(downloadPath: itemsPath), progressRatio: 1.0)
    }

    private func updateUniqueChampionJSONs() {
        let championNames = self.getListOfChampionNames().sorted { $0 < $1 }
        for championName in championNames {
            self.downloadJson(targetType: .champion(downloadPath: FilePaths.championJson(name: championName).path,
                                                    name: championName),
                              progressRatio: 1.0 / Double(championNames.count))
        }
    }

    private func downloadJson(targetType: MoyaProvider<DataDragon>.Target, progressRatio: Double) {
        var cancellable: AnyCancellable? = nil
        cancellable = self.ddProvider.requestWithProgressPublisher(targetType)
            .receive(on: DispatchQueue.global(qos: .utility))
            .sink(receiveCompletion: { [weak self] completionType in
                print(completionType)
                self?.updateProgress.increaseProgress(forPhase: targetType, by: progressRatio)
            }) { [weak self] progressResponse in
                if progressResponse.completed {
                    self?.bagSafetyQueue.async(flags: .barrier) {
                        self?.cancellableBag.remove(cancellable!)
                    }
                }
            }

        self.cancellableBag.insert(cancellable!)
    }

    private func getListOfChampionNames() -> [String] {
        let champListData = try! Data(contentsOf: FilePaths.championsJson.path)
        let champListObject = try! JSONDecoder().decode(ChampionsJSON.self, from: champListData)

        return champListObject.data.map { $0.key }
    }
}

extension LeagueApi {
    class UpdateProgress : ObservableObject {
        @Published var championsJSONProgress: Double = 0.0
        @Published var itemsJSONProgress: Double = 0.0
        @Published var championUniqueJSONsProgress: Double = 0.0

        func increaseProgress(forPhase targetType: MoyaProvider<DataDragon>.Target, by value: Double) {
            DispatchQueue.main.async {
                switch targetType {
                    case .champion: self.championUniqueJSONsProgress += value
                    case .items: self.itemsJSONProgress += value
                    case .champions: self.championsJSONProgress += value
                    default: break
                }
            }
        }

        func finished() -> Bool {
            return !championsJSONProgress.isLessThanOrEqualTo(0.9999)
                && !itemsJSONProgress.isLessThanOrEqualTo(0.9999)
                && !championUniqueJSONsProgress.isLessThanOrEqualTo(0.9999)
        }

        func willFinishWithValues(championsProgress: Double, itemsProgress: Double, uniqueChampionsProgress: Double) -> Bool {
            //This is needed because publishers are called in WillChange, not in DidChange.
            return !championsProgress.isLessThanOrEqualTo(0.9999)
                && !itemsProgress.isLessThanOrEqualTo(0.9999)
                && !uniqueChampionsProgress.isLessThanOrEqualTo(0.9999)
        }
    }
}
