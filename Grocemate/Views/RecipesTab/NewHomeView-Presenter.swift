//
//  NewHomeView-Presenter.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/27/24.
//

import Presenting
import SwiftUI

//enum NewHomeRoute: Presentable {
//    case documentScanner(([UIImage]) -> Void)
//
//    var id: UUID { .init() }
//
//    var body: some View {
//        switch self {
//        case .documentScanner(let documentsScannedClosure):
//            <#code#>
//        }
//    }
//}


//enum HomeViewRoute: Presentable {
//    typealias ImageScannerClosure = ([UIImage]) -> Void
//
//    case documentScanner(ImageScannerClosure)
////    case editCard
////    case imageROI
////    case manuallyCreateCard
//
//    var id: UUID { .init() }
//
//    var body: some View {
//        switch self {
////        case .imageROI:
////            if let image = homeViewModel.selectedImage {
////                ImageWithROI(image: image)
////            } else {
////                EmptyView()
////            }
////        case .editCard:
////            if let selectedCard = homeViewModel.selectedCard {
////                CardDetailView<EditCardViewModel>(viewModel:
////                                                    EditCardViewModel(
////                                                        coreDataController: .shared,
////                                                        ingredientCard: selectedCard
////                                                    )
////                )
////            }
////        case .manuallyCreateCard:
////            CardDetailView<CreateCardViewModel>(
////                viewModel: CreateCardViewModel(coreDataController: .shared, context: coreDataController.newContext)
////            )
//        case .documentScanner(let imageScannerClosure):
//            DocumentScannerView(documentsScannedClosure: imageScannerClosure)
//        }
//    }
//}
//
