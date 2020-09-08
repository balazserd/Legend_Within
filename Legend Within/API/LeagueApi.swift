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

/* Singleton object, responsible for everything related to the League API. */
public class LeagueApi : ObservableObject {
    private(set) static var shared = LeagueApi()
    private init() {
        self.providerQueue = DispatchQueue(label: "leagueApi.DataDragonAPIQueue", qos: .userInitiated, attributes: .concurrent)
        self.ddProvider = MoyaProvider<DataDragon>(callbackQueue: self.providerQueue)
        self.setupUpdateCycleSubscriptions()
    }

    @Published var newVersionExists: Bool? = nil
    @Published var updateProgress = UpdateProgress()
    @Published var updatedFailedDueToNoSpace: Bool? = nil
    private var versionToDownload: String? = nil
    private var cancellableBag = Set<AnyCancellable>()

    //Dedicated queue for handling the cancellableBag in a thread safe way.
    private let bagSafetyQueue = DispatchQueue(label: "leagueApi.bagSafetyQueue", qos: .userInteractive)

    private let providerQueue: DispatchQueue
    private let ddProvider: MoyaProvider<DataDragon>

    //MARK:- Static members
    class func apiUrl(region: Region) -> URL {
        URL(string: String("https://\(region.urlPrefix).api.riotgames.com"))!
    }

    static let commonHeaders: [String : String]? = [
        "X-Riot-Token" : LeagueApi.key
    ]

    //MARK: - Update cycle
    private func setupUpdateCycleSubscriptions() {

        //When a new version exists, begin update cycle.
        $newVersionExists
            .sink { [weak self] exists in
                guard exists != nil && exists! else { return }
                self?.beginUpdateData()
            }
            .store(in: &cancellableBag)

        //Track progress. When all done, mark new downloaded version and return update cycle to initial state.
        Publishers.CombineLatest3(Publishers.CombineLatest4(updateProgress.$championsJSONProgress,
                                                            updateProgress.$itemsJSONProgress,
                                                            updateProgress.$championUniqueJSONsProgress,
                                                            updateProgress.$queuesJSONProgress),
                                  Publishers.CombineLatest4(updateProgress.$mapsJSONProgress,
                                                            updateProgress.$runesJSONProgress,
                                                            updateProgress.$runeIconsProgress,
                                                            updateProgress.$itemIconsProgress),
                                  Publishers.CombineLatest3(updateProgress.$championIconsProgress,
                                                            updateProgress.$summonerSpellsJSONProgress,
                                                            updateProgress.$summonerSpellIconsProgress))
            .sink { [weak self] progress in
                guard let self = self else { return }

                if UpdateProgress.willFinishWithValues(championsProgress: progress.0.1,
                                                       itemsProgress: progress.0.1,
                                                       uniqueChampionsProgress: progress.0.2,
                                                       queuesProgress: progress.0.3,
                                                       mapsProgress: progress.1.0,
                                                       runesProgress: progress.1.1,
                                                       runeIconsProgress: progress.1.2,
                                                       itemIconsProgress: progress.1.3,
                                                       championIconsProgress: progress.2.0,
                                                       summonerSpellsProgress: progress.2.1,
                                                       summonerSpellIconsProgress: progress.2.2) {
                    UserDefaults.standard.set(self.versionToDownload, forKey: Settings.currentDownloadedVersion)
                    self.updateProgress = UpdateProgress()
                    self.versionToDownload = nil
                    self.newVersionExists = false
                }
            }
            .store(in: &cancellableBag)

        //When champions JSON is downloaded, begin downloading individual champion JSON files and champion icons.
        updateProgress.$championsJSONProgress
            .sink { [weak self] progress in
                if progress.isEqual(to: 1.0) {
                    self?.updateUniqueChampionJSONs()
                    self?.updateChampionIcons()
                }
            }
            .store(in: &cancellableBag)

        //When the items JSON is downloaded, begin downloading all item icons.
        updateProgress.$itemsJSONProgress
            .sink { [weak self] progress in
                if progress.isEqual(to: 1.0) {
                    self?.updateItemIcons()
                }
            }
            .store(in: &cancellableBag)

        //When the summoner spells JSON is downloaded, begin downloading all summoner spell icons.
        updateProgress.$summonerSpellsJSONProgress
            .sink { [weak self] progress in
                if progress.isEqual(to: 1.0) {
                    self?.updateSummonerSpellIcons()
                }
            }
            .store(in: &cancellableBag)

        //When the runes JSON is downloaded, begin downloading all rune icons.
        updateProgress.$runesJSONProgress
            .sink { [weak self] progress in
                if progress.isEqual(to: 1.0) {
                    self?.updateRuneIcons()
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

                    UserDefaults.standard.set(latestVersion, forKey: Settings.versionToDownload)
                    self.versionToDownload = latestVersion
                }

                DispatchQueue.main.async {
                    self?.newVersionExists = newerExists //Overwrite this with true in debug to force update cycle.
                }

                self?.cancellableBag.remove(cancellable!)
            })

        self.cancellableBag.insert(cancellable!)
    }

    func beginUpdateData() {
        guard checkForEnoughSpace() else {
            self.updatedFailedDueToNoSpace = true
            return
        }

        let dpGroup = DispatchGroup()

        //will download champion icons and individual jsons
        self.downloadJson(targetType: .champions(downloadPath: FilePaths.championsJson.path), progressRatio: 1.0, groupedIn: dpGroup)
        //will download item icons
        self.downloadJson(targetType: .items(downloadPath: FilePaths.itemsJson.path), progressRatio: 1.0, groupedIn: dpGroup)
        self.downloadJson(targetType: .maps(downloadPath: FilePaths.mapsJson.path), progressRatio: 1.0, groupedIn: dpGroup)
        self.downloadJson(targetType: .queues(downloadPath: FilePaths.queuesJson.path), progressRatio: 1.0, groupedIn: dpGroup)
        self.downloadJson(targetType: .runes(downloadPath: FilePaths.runesJson.path), progressRatio: 1.0, groupedIn: dpGroup)
        //will download summoner spell icons
        self.downloadJson(targetType: .summonerSpells(downloadPath: FilePaths.summonerSpellsJson.path), progressRatio: 1.0, groupedIn: dpGroup)
    }

    //MARK:- JSON downloads
    /* Downloads the corresponding JSON file for the specified target. */
    private func downloadJson(targetType: MoyaProvider<DataDragon>.Target, progressRatio: Double, groupedIn dispatchGroup: DispatchGroup? = nil) {
        dispatchGroup?.enter()

        var cancellable: AnyCancellable? = nil
        cancellable = self.ddProvider.requestWithProgressPublisher(targetType)
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .retry(3)
            .sink(receiveCompletion: { [weak self] completionType in
                print(completionType)
                switch completionType {
                    case .failure(let error): break
                    case .finished:
                        DispatchQueue.main.async {
                            self?.updateProgress.increaseProgress(forPhase: targetType, by: progressRatio)
                            dispatchGroup?.leave()
                        }
                }
            }) { [weak self] progressResponse in
                if progressResponse.completed {
                    self?.bagSafetyQueue.async(flags: .barrier) {
                        self?.cancellableBag.remove(cancellable!)
                    }
                }
            }

        self.bagSafetyQueue.async(flags: .barrier) {
            self.cancellableBag.insert(cancellable!)
        }
    }

    /* Downloads all champion unique JSON files. (Uses multithreading) */
    private func updateUniqueChampionJSONs() {
        let championNames = self.getListOfChampionNames().sorted { $0 < $1 }
        DispatchQueue.concurrentPerform(iterations: championNames.count) { i in
            self.downloadJson(targetType: .champion(downloadPath: FilePaths.championJson(name: championNames[i]).path,
                                                    name: championNames[i]),
                              progressRatio: 1.0 / Double(championNames.count))
        }
    }

    //MARK:- Icon downloads
    private func updateItemIcons() {
        let itemIconIds = self.getListOfItemIds()
        DispatchQueue.concurrentPerform(iterations: itemIconIds.count) { i in
            self.downloadIcon(for: .itemIcon(downloadPath: FilePaths.itemIcon(id: itemIconIds[i]).path,
                                             id: itemIconIds[i]),
                              progressRatio: 1.0 / Double(itemIconIds.count))
        }
    }

    private func updateChampionIcons() {
        let championIconFileNames = self.getListOfChampionIconNames()
        DispatchQueue.concurrentPerform(iterations: championIconFileNames.count) { i in
            self.downloadIcon(for: .championIcon(downloadPath: FilePaths.championIcon(fileName: championIconFileNames[i]).path,
                                                 name: championIconFileNames[i]),
                              progressRatio: 1.0 / Double(championIconFileNames.count))
        }
    }

    private func updateSummonerSpellIcons() {
        let summonerSpellIconNames = self.getListOfSummonerSpellIconNames()
        DispatchQueue.concurrentPerform(iterations: summonerSpellIconNames.count) { i in
            self.downloadIcon(for: .summonerSpellIcon(downloadPath: FilePaths.summonerSpellIcon(fileName: summonerSpellIconNames[i]).path,
                                                      name: summonerSpellIconNames[i]),
                              progressRatio: 1.0 / Double(summonerSpellIconNames.count))
        }
    }

    private func updateRuneIcons() {
        let runeIconPaths = self.getListOfRuneIconNames()

        DispatchQueue.concurrentPerform(iterations: runeIconPaths.count) { i in
            self.downloadIcon(for: .runeIcon(downloadPath: FilePaths.runeIcon(filePath: runeIconPaths[i]).path,
                                             path: runeIconPaths[i]),
                              progressRatio: 1.0 / Double(runeIconPaths.count))
        }
    }

    private func downloadIcon(for targetType: MoyaProvider<DataDragon>.Target, progressRatio: Double) {
        var cancellable: AnyCancellable? = nil
        cancellable = self.ddProvider.requestWithProgressPublisher(targetType)
            .receive(on: DispatchQueue.global(qos: .userInteractive))
            .retry(3)
            .sink(receiveCompletion: { [weak self] completionType in
                switch completionType {
                    case .failure(let error): break
                    case .finished:
                        DispatchQueue.main.async {
                            self?.updateProgress.increaseProgress(forPhase: targetType, by: progressRatio)
                        }
                }
            }) { [weak self] progressResponse in
                if progressResponse.completed {
                    self?.bagSafetyQueue.async(flags: .barrier) {
                        self?.cancellableBag.remove(cancellable!)
                    }
                }
            }

        self.bagSafetyQueue.async(flags: .barrier) {
            self.cancellableBag.insert(cancellable!)
        }
    }

    //MARK:- Array fetchers for common objects (champion names, item ids, etc...)
    private func getListOfChampionNames() -> [String] {
        let champListData = try! Data(contentsOf: FilePaths.championsJson.path)
        let champListObject = try! JSONDecoder().decode(ChampionsJSON.self, from: champListData)

        return champListObject.data.map { $0.key }
    }

    private func getListOfChampionIconNames() -> [String] {
        let champListData = try! Data(contentsOf: FilePaths.championsJson.path)
        let champListObject = try! JSONDecoder().decode(ChampionsJSON.self, from: champListData)

        return champListObject.data.map { $0.value.image.full }
    }

    private func getListOfSummonerSpellIconNames() -> [String] {
        let summonerSpellListData = try! Data(contentsOf: FilePaths.summonerSpellsJson.path)
        let summonerSpellListObject = try! JSONDecoder().decode(SummonerSpellsJSON.self, from: summonerSpellListData)

        return summonerSpellListObject.data.map { $0.value.image.full }
    }

    private func getListOfItemIds() -> [Int] {
        let itemListData = try! Data(contentsOf: FilePaths.itemsJson.path)
        let itemListObject = try! JSONDecoder().decode(ItemsJSON.self, from: itemListData)

        return itemListObject.data.map { $0.key }
    }

    private func getListOfRuneIconNames() -> [String] {
        let runeListData = try! Data(contentsOf: FilePaths.runesJson.path)
        let runeListObject = try! JSONDecoder().decode([RunePath].self, from: runeListData)

        var runeIconNames = [String]()

        for runePath in runeListObject {
            runeIconNames.append(runePath.icon)

            for slot in runePath.slots {
                for rune in slot.runes {
                    runeIconNames.append(rune.icon)
                }
            }
        }

        return runeIconNames
    }

    //MARK:- Miscellaneous

    /* Checks if there is at least 40 Megabytes of free space on the device. */
    private func checkForEnoughSpace() -> Bool {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileSystemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory.path)

        if let freeSpaceInBytes = (fileSystemAttributes?[.systemFreeSize] as? NSNumber)?.doubleValue {
            return !(freeSpaceInBytes / pow(1024.0, 2)).isLessThanOrEqualTo(40.0)
        }

        return false
    }
}
