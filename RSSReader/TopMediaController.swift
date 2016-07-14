/*

This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike
4.0 International License, by Yong Bakos.

*/

import UIKit

class TopMediaController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBInspectable var feedURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSURLRequest(URL: NSURL(string: feedURL)!)
        print(request)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            if let jsonData = data,
                feed = (try? NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)) as? NSDictionary,
                title = feed.valueForKeyPath("feed.entry.im:name.label") as? String,
                artist = feed.valueForKeyPath("feed.entry.im:artist.label") as? String,
                imageURLs = feed.valueForKeyPath("feed.entry.im:image") as? [NSDictionary] {
                    print("if loop")
                    if let imageURL = imageURLs.last,
                        imageURLString = imageURL.valueForKeyPath("label") as? String {
                        print(imageURLString)
                            self.loadImageFromURL(NSURL(string:imageURLString)!)
                    }
                self.titleLabel.text = title
                self.titleLabel.hidden = false
                self.artistLabel.text = artist
                self.artistLabel.hidden = false
                
            }
            print("endif loop")
        }
    }
    
    func loadImageFromURL(URL: NSURL) {
        let request = NSURLRequest(URL: URL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            if let imageData = data {
                self.imageView.image = UIImage(data: imageData)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
}
