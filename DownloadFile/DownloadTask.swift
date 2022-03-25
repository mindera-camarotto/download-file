import Foundation

protocol DownloadDelegate: AnyObject {
    func didFinishDownload(at location: URL)
}

class DownloadTask: NSObject {
    weak var delegate: DownloadDelegate?
    
    func downloadFile(from url: URL) {
        URLSession(configuration: .default, delegate: self,
                   delegateQueue: OperationQueue())
        .downloadTask(with: url)
        .resume()
    }
}

extension DownloadTask: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else {
            // Error needs to be handled
            return
        }
        let cachesPath = FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first
        guard let destinationURL = cachesPath?.appendingPathComponent(url.lastPathComponent) else {
            // Error needs to be handled
            return
        }
        
        try? FileManager.default.removeItem(at: destinationURL)
        
        do {
            try FileManager.default.moveItem(at: location, to: destinationURL)
        } catch let error {
            // Error needs to be handled
            print("Error - could not move item")
            print("Error - \(error.localizedDescription)")
            return
        }
        
        DispatchQueue.main.async {
            self.delegate?.didFinishDownload(at: destinationURL)
        }
    }
}
