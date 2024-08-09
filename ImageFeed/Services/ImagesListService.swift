//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.08.2024.
//

import Foundation

final class ImagesListService {
    // MARK: - properties
    static let shared = ImagesListService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var photos: [Photo] = [] // downloaded photos
    private var lastLoadedPage: Int?
    private let tokenStorage = OAuth2TokenStorage.shared
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Init
    private init() { }
    
    // MARK: - Public methods
    // Скачивать больше одной страницы за раз не будем; если идёт закачка — будем отправлять новый запрос только после её завершения.
    func fetchPhotosNextPage() {
        
        assert(Thread.isMainThread)
        
        // если идёт закачка, то нового сетевого запроса не создаётся, а выполнение функции прерывается;
        guard task == nil else {
            print("DEBUG",
                  "[\(String(describing: self)).\(#function)]:",
                  "Task is already in progress!",
                  separator: "\n")
            return
        }
        
        // Здесь получим страницу номер 1, если ещё не загружали ничего,
        // и следующую страницу (на единицу больше), если есть предыдущая загруженная страница
        
        // функция внутри себя определяет номер следующей страницы для закачки (номер не должен сообщаться извне, как параметр функции);
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard
            let token = tokenStorage.token
        else {
            return
        }
        
        guard
            let request = Endpoint.getImages(token: token, page: nextPage).request
        else {
            return
        }
        
        print("LIST IMAGES REQUEST: \(request)")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let object):
                DispatchQueue.main.async {
                    for photo in object {
                        self.photos.append(Photo(from: photo))
                    }
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching images:",
                      error.localizedDescription,
                      separator: "\n")
            }
            DispatchQueue.main.async {
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}
