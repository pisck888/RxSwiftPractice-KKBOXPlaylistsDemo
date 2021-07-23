//
//  CustomTableViewCell.swift
//  RxSwiftChallenge
//
//  Created by TSAI TSUNG-HAN on 2021/5/6.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PlaylistsCell: UITableViewCell {

  var disposeBag = DisposeBag()

  @IBOutlet weak var mainImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var heartButton: UIButton!

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  func setup(track: Track, viewModel: PlaylistsViewModel) {
    let url = URL(string: track.album.images[0].url)
    self.selectionStyle = .none
    self.contentView.alpha = 0
    titleLabel.text = track.name
    mainImage.kf.setImage(with: url)
    heartButton.isSelected = viewModel.favoriteTracks.contains(track.id)

    heartButton.rx.tap.subscribe { _ in
      if viewModel.favoriteTracks.contains(track.id) {
        viewModel.favoriteTracks.removeAll { $0 == track.id }
      } else {
        viewModel.favoriteTracks.append(track.id)
      }
      self.heartButton.isSelected.toggle()
    }.disposed(by: disposeBag)
  }
}
