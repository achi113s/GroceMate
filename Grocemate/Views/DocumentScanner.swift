//
//  DocumentScanner.swift
//  Grocemate
//
//  Created by Giorgio Latour on 3/5/24.
//

import SwiftUI
import VisionKit

struct DocumentScanner: UIViewControllerRepresentable {
    typealias UIViewControllerType = VNDocumentCameraViewController

    @Environment(\.presentationMode) private var presentationMode

    private var onDocumentsScanned: ([UIImage]) -> Void

    public init(onDocumentsScanned: @escaping ([UIImage]) -> Void) {
        self.onDocumentsScanned = onDocumentsScanned
    }

    func makeCoordinator() -> DocumentScannerCoordinator {
        return DocumentScannerCoordinator {
            self.presentationMode.wrappedValue.dismiss()
        } onDocumentsScanned: { _ in
            print("hello")
        }
    }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let documentScannerVC = VNDocumentCameraViewController()

        documentScannerVC.delegate = context.coordinator

        return documentScannerVC
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }

    class DocumentScannerCoordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        private let onDismiss: () -> Void
        private let onDocumentsScanned: ([UIImage]) -> Void

        fileprivate init(onDismiss: @escaping () -> Void, onDocumentsScanned: @escaping ([UIImage]) -> Void) {
            self.onDismiss = onDismiss
            self.onDocumentsScanned = onDocumentsScanned
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController,
                                          didFinishWith scan: VNDocumentCameraScan) {
            var images: [UIImage] = [UIImage]()

            for pageNumber in 0..<scan.pageCount {
                let image = scan.imageOfPage(at: pageNumber)

                images.append(image)
            }

            self.onDocumentsScanned(images)

            self.onDismiss()
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController,
                                          didFailWithError error: Error) {
            self.onDismiss()
        }

        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            self.onDismiss()
        }
    }
}
