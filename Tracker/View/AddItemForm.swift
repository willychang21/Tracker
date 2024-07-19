import SwiftUI
import Vision
import UIKit
import CoreML
import NaturalLanguage

struct AddItemForm: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: MainViewModel
    @ObservedObject var categoryViewModel: CategoryViewModel
    @State private var name = ""
    @State private var selectedCategory = ""
    @State private var produceDay = Date()
    @State private var expirationDay = Date()
    @State private var showAlert = false
    @State private var showCustomCategorySheet = false
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Name", text: $name)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(categoryViewModel.categories.map { $0.name }, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                }) {
                                    Text(category)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(selectedCategory == category ? Color.blue : Color.gray)
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                            }
                            Button(action: {
                                showCustomCategorySheet.toggle()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    
                    DatePicker("Produce Day", selection: $produceDay, displayedComponents: .date)
                    DatePicker("Expiration Day", selection: $expirationDay, displayedComponents: .date)
                }
                
                Button(action: {
                    showImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Use Camera to Add Item")
                    }
                }
            }
            .navigationTitle("Add New Item")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Add") {
                if name.isEmpty || selectedCategory.isEmpty {
                    showAlert = true
                } else {
                    let newItem = Item(name: name, category: selectedCategory, produceDay: produceDay, expirationDay: expirationDay)
                    viewModel.addItem(item: newItem)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .disabled(name.isEmpty || selectedCategory.isEmpty))
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Invalid Input"),
                    message: Text("Item name and category cannot be empty."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(isPresented: $showCustomCategorySheet) {
                CustomCategorySheet(categoryViewModel: categoryViewModel, selectedCategory: $selectedCategory)
            }
            .sheet(isPresented: $showImagePicker, onDismiss: processImage) {
                ImagePicker(image: $inputImage)
            }
        }
    }
    
    func processImage() {
        guard let inputImage = inputImage else { return }
        
        let requestHandler = VNImageRequestHandler(cgImage: inputImage.cgImage!)
        
        let textRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            var recognizedTexts: [String] = []
            for observation in observations {
                let recognizedText = observation.topCandidates(1).first?.string ?? ""
                recognizedTexts.append(recognizedText)
                print("Recognized Text: \(recognizedText)")
            }
            // Parse recognized texts to extract item details
            updateItemDetails(with: recognizedTexts)
        }
        
        guard let objectDetectionModel = try? VNCoreMLModel(for: YOLOv3().model) else {
            fatalError("Failed to load Core ML model")
        }
        
        let objectDetectionRequest = VNCoreMLRequest(model: objectDetectionModel) { (request, error) in
            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            for result in results {
                // Use object detection results
                print(result.labels)
            }
        }
        
        do {
            try requestHandler.perform([textRequest, objectDetectionRequest])
        } catch {
            print("Failed to perform text recognition: \(error)")
        }
    }
    
    func updateItemDetails(with texts: [String]) {
        let textAnalyzer = TextAnalyzer()
        textAnalyzer.analyzeText(texts) { (name, expirationDate) in
            self.name = name ?? ""
            if let expDate = expirationDate {
                self.expirationDay = expDate
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
