//
//  ViewController.swift
//  RxSwiftChallenge
//
//  Created by TSAI TSUNG-HAN on 2021/5/5.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import SnapKit
import MJRefresh

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  let disposeBag = DisposeBag()

  let viewModel = PlaylistsViewModel()

  let mainImage = UIImageView()

  let indicator = UIActivityIndicatorView()

  lazy var headerView: UIView = {
    let view = UIView()

    view.addSubview(mainImage)
    mainImage.snp.makeConstraints { make in
      make.top.bottom.left.right.equalToSuperview()
    }
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.getTracks()
    setupTableView()
    setupMJFooter()
    bindViewModel()
  }

  func setupMJFooter() {
    let footer = MJRefreshBackNormalFooter {
      self.viewModel.noMoreData.subscribe { [weak self] noMoreData in
        if noMoreData.element == true {
          self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
        } else {
          self?.viewModel.getTracks()
          self?.tableView.mj_footer?.endRefreshing()
        }
      }.disposed(by: self.disposeBag)
    }
    tableView.mj_footer = footer
  }


  func setupTableView() {
    tableView.addSubview(indicator)
    indicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    indicator.style = .large
    indicator.hidesWhenStopped = true

    headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.width)
    tableView.tableHeaderView = headerView

    viewModel.tracks.bind(onNext: { [weak self] tracks in
      let url = URL(string: tracks[0].album.images[1].url)
      self?.mainImage.kf.setImage(with: url)
    }).disposed(by: disposeBag)

    tableView.rx.willDisplayCell.subscribe { cell, index in
      UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
        cell.contentView.alpha = 1
      }
    }.disposed(by: disposeBag)

    tableView.rx.contentOffset.subscribe { [weak self] in
      guard let self = self else {
        return
      }
      let offsetY = ($0.element?.y ?? 0 ) + 48.0

      if offsetY > 0 {
        self.mainImage.alpha = (self.mainImage.frame.height - offsetY) / self.mainImage.frame.height
      } else {
        self.mainImage.alpha = 1
        let zoomRatio = -offsetY / 500
        self.mainImage.transform = CGAffineTransform(scaleX: 1 + zoomRatio, y: 1 + zoomRatio)
      }
    }.disposed(by: disposeBag)
  }

  func bindViewModel() {
    viewModel.tracks.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: PlaylistsCell.self)) { [unowned self] row, track, cell in
      cell.setup(track: track, viewModel: self.viewModel)
    }.disposed(by: disposeBag)

    viewModel.isLoading.bind(to: indicator.rx.isAnimating).disposed(by: disposeBag)

    tableView.rx.modelSelected(Track.self).subscribe { [weak self] track in
      let url = URL(string: track.element?.album.images[1].url ?? "")
      self?.mainImage.kf.setImage(with: url)
    }.disposed(by: disposeBag)
  }
}









