import UIKit

class ViewController: UIViewController {
    
    private let downloadTask = DownloadTask()
    private let url = "https://www.tutorialspoint.com/swift/swift_tutorial.pdf"
    private var downloadedFileURL: URL?
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadTask.delegate = self
    }
    
    @IBAction func downloadFileButtonTapped(_ sender: Any) {
        let url = URL(string: url)!
        downloadTask.downloadFile(from: url)
        messageLabel.text = "Downloading file..."
    }
    
    @IBAction func shareFileButtonTapped(_ sender: Any) {
        guard let url = downloadedFileURL else {
            messageLabel.text = "Download the file first"
            return
        }
        let activity = UIActivityViewController(activityItems: [url],
                                                applicationActivities: nil)
        present(activity, animated: true)
    }
    
    @IBAction func presentFileButtonTapped(_ sender: Any) {
        guard let url = downloadedFileURL else {
            messageLabel.text = "Download the file first"
            return
        }
        let fileView = UIDocumentInteractionController(url: url)
        fileView.delegate = self
        fileView.presentPreview(animated: true)
    }
    
}

extension ViewController: DownloadDelegate {
    func didFinishDownload(at location: URL) {
        print("download location: \(location)")
        messageLabel.text =  "Download completed"
        downloadedFileURL = location
    }
}

extension ViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        self
    }
}
