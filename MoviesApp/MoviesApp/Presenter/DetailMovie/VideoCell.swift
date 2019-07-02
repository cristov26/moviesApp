//
//  VideoCell.swift
//  MoviesApp
//
//  Created by Cristian Tovar on 11/16/17.
//  Copyright © 2017 Cristian Tovar. All rights reserved.
//

import UIKit
import Lottie
import Alamofire

class VideoCell: UITableViewCell {
    @IBOutlet weak var iconError: UIImageView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var playerView: YTPlayerView!
    var lottieView = AnimationView()
    var isLoaded = false
    var loadedKey: String?
    var videoKey: String?
    var completionBlock: LottieCompletionBlock?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconError.isHidden = true
        animationView.isHidden = false
        playerView.isHidden = false
        isLoaded = false
    }
    
    func loadVideo(VideoId: String) {
        guard loadedKey != videoKey else {
            animationView.isHidden = true
            return
        }
        if lottieView.animation == nil {
            let animation = Animation.named("YouTubeAnimation")
            lottieView.animation = animation
            lottieView.contentMode = .scaleAspectFit
            lottieView.frame = CGRect(x: 0, y: 0, width: animationView.frame.width, height: animationView.frame.height)
            animationView.addSubview(lottieView)
        }
        if lottieView.frame.width != animationView.frame.height {
            lottieView.frame = CGRect(x: 0, y: 0, width: animationView.frame.width, height: animationView.frame.height)
        }
        if !(NetworkReachabilityManager()?.isReachable ?? false) {
            animationView.isHidden = true
            playerView.isHidden = true
            iconError.isHidden = false
            return
        }
        if completionBlock == nil {
           completionBlock = { [weak self] finished in
                self?.animationEnded(finished: finished)
            }
        }
        lottieView.animationSpeed = 2
        lottieView.play(fromProgress: 0,
                        toProgress: 1,
                        loopMode: LottieLoopMode.playOnce,
                        completion: completionBlock)

        iconError.isHidden = true
        if playerView.load(withVideoId: VideoId) {
            playerView.delegate = self
        } else {
            lottieView.stop()
            animationView.isHidden = true
            iconError.isHidden = false
        }
    }
    
    func animationEnded(finished: Bool, completion: LottieCompletionBlock? = nil) {
        if finished && self.isLoaded {
            animationView.isHidden = true
        } else {
            lottieView.play(fromProgress: 0,
                            toProgress: 1,
                            loopMode: LottieLoopMode.playOnce,
                            completion: completionBlock)
        }
    }
    
}

extension VideoCell: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        isLoaded = true
        loadedKey = videoKey
    }
}
