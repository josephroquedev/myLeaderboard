//
//  ImageLoader.swift
//  MyLeaderboard
//
//  Created by Joseph Roque on 2019-07-09.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import UIKit

enum ImageLoaderError: Error {
	case invalidURL
	case invalidData
	case networkingError(Error)
	case invalidResponse
	case invalidHTTPResponse(Int)
}

typealias ImageLoaderResult = Result<(URL, UIImage), ImageLoaderError>

class ImageLoader {
	typealias Completion = (ImageLoaderResult) -> Void

	static let shared: ImageLoader = ImageLoader()

	private let cache = NSCache<NSURL, UIImage>()
	private let queryLock = NSLock()
	private var queryCompletionQueue: [String: [Completion]] = [:]

	let queryIfCached: Bool

	init(queryIfCached: Bool = false) {
		self.queryIfCached = queryIfCached
	}

	@discardableResult
	func fetch(string: String, completion: @escaping Completion) -> UIImage? {
		func finishRequest(_ result: ImageLoaderResult) {
			DispatchQueue.main.async {
				completion(result)
			}
		}

		let cachedImage = cached(string: string)
		if let cachedImage = cachedImage, !queryIfCached {
			return cachedImage
		}

		DispatchQueue.global(qos: .background).async { [unowned self] in
			guard let url = URL(string: string) else {
				finishRequest(.failure(.invalidURL))
				return
			}

			self.fetch(url: url, completion: completion)
		}

		return cachedImage
	}

	@discardableResult
	func fetch(url: URL, completion: @escaping Completion) -> UIImage? {
		func finishRequest(_ result: ImageLoaderResult) {
			DispatchQueue.main.async {
				completion(result)
			}
		}

		let cachedImage = cached(url: url)
		if let cachedImage = cachedImage, !queryIfCached {
			return cachedImage
		}

		DispatchQueue.global(qos: .background).async { [unowned self] in
			self.performFetch(for: url, completion: finishRequest)
		}

		return cachedImage
	}

	func cached(string: String) -> UIImage? {
		guard let url = URL(string: string) else { return nil }
		return cached(url: url)
	}

	func cached(url: URL) -> UIImage? {
		return cache.object(forKey: url as NSURL)
	}

	private func performFetch(for url: URL, completion: @escaping Completion) {
		defer { queryLock.unlock() }
		queryLock.lock()

		func finished(_ result: ImageLoaderResult) {
			defer { queryLock.unlock() }
			queryLock.lock()

			if let queryQueue = queryCompletionQueue[url.absoluteString] {
				queryQueue.forEach { $0(result) }
			}
			queryCompletionQueue[url.absoluteString] = nil
		}

		if var queryQueue = queryCompletionQueue[url.absoluteString] {
			queryQueue.append(completion)
			queryCompletionQueue[url.absoluteString] = queryQueue
			return
		}

		queryCompletionQueue[url.absoluteString] = [completion]
		URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
			guard error == nil else {
				finished(.failure(.networkingError(error!)))
				return
			}

			guard let response = response as? HTTPURLResponse else {
				finished(.failure(.invalidResponse))
				return
			}

			guard (200..<400).contains(response.statusCode) else {
				finished(.failure(.invalidHTTPResponse(response.statusCode)))
				return
			}

			guard let data = data else {
				finished(.failure(.invalidData))
				return
			}

			self.image(for: data, fromURL: url, completion: finished)
		}.resume()
	}

	private func image(for data: Data, fromURL url: URL, completion: @escaping Completion) {
		guard let image = UIImage(data: data) else {
			completion(.failure(.invalidData))
			return
		}

		cache.setObject(image, forKey: url as NSURL)
		completion(.success((url, image)))
	}
}
