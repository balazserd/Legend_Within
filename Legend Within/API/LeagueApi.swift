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

    @Published var newVersionExists: Bool = false
    @Published var updateProgress = UpdateProgress()
    private var versionToDownload: String? = nil
    private var cancellableBag = Set<AnyCancellable>()

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
                guard exists else { return }
                self?.beginUpdateData()
            }
            .store(in: &cancellableBag)

        Publishers.CombineLatest3(updateProgress.$championsJSONProgress,
                                  updateProgress.$championUniqueJSONsProgress,
                                  updateProgress.$itemsJSONProgress)
            .sink { [weak self] progress in
                guard let self = self else { return }

                if self.updateProgress.finished() {
                    UserDefaults.standard.set(self.versionToDownload, forKey: Settings.currentDownloadedVersion)
                    self.updateProgress = UpdateProgress()
                    self.versionToDownload = nil
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
                }

                self?.cancellableBag.remove(cancellable!)
            })

        self.cancellableBag.insert(cancellable!)
    }

    func beginUpdateData() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let championsPath = documentsDirectory.appendingPathComponent("champion.json")
        let itemsPath = documentsDirectory.appendingPathComponent("item.json")

        self.downloadJson(targetType: .champions(downloadPath: championsPath), progressRatio: 0.025)
        self.downloadJson(targetType: .items(downloadPath: itemsPath), progressRatio: 0.025)
    }

    private func updateUniqueChampionJSONs() {
        let championNames = self.getListOfChampionNames().sorted { $0 < $1 }
        for championName in championNames {
            self.downloadJson(targetType: .champion(downloadPath: FilePaths.championJson(name: championName).path,
                                                    name: championName),
                              progressRatio: 0.95 / Double(championNames.count))
        }
    }

    private func downloadJson(targetType: MoyaProvider<DataDragon>.Target, progressRatio: Double) {
        var cancellable: AnyCancellable? = nil
        cancellable = self.ddProvider.requestWithProgressPublisher(targetType)
            .receive(on: DispatchQueue.global(qos: .utility))
            .sink(receiveCompletion: { completionType in
                print(completionType)
            }) { [weak self] progressResponse in
                DispatchQueue.main.async {
                    self?.updateProgress.setProgress(forPhase: targetType, to: progressResponse.progress * progressRatio)
                }

                if progressResponse.completed {
                    self?.cancellableBag.remove(cancellable!)
                    self?.updateProgress.setProgress(forPhase: targetType, to: 1.0)
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

        func setProgress(forPhase targetType: MoyaProvider<DataDragon>.Target, to value: Double) {
            switch targetType {
                case .champion: self.championUniqueJSONsProgress = value
                case .items: self.itemsJSONProgress = value
                case .champions: self.championsJSONProgress = value
                default: break
            }
        }

        func finished() -> Bool {
            return championsJSONProgress.isEqual(to: 1.0)
                && itemsJSONProgress.isEqual(to: 1.0)
                && championUniqueJSONsProgress.isEqual(to: 1.0)
        }
    }
}
