import AVFoundation
import UIKit


class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var listeIngredient = ["pate","poulet","salade","spaghetti", "spagetti", "chicken", "ham", "cheese", "fromage", "jambon", "pene", "beef", "steack"]
    var produit:String = ""
    var listPlat:[Plat] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        
        //dismiss(animated: true)
    }
    
    

    func found(code: String) {
        getProductFromBarcode(codebarre: code)
        
    }
    
    func getProductFromBarcode(codebarre:String)
    {
        let url = "https://world.openfoodfacts.org/api/v2/search?code=\(codebarre)&fields=code,product_name";
        struct Response: Codable{
            let count:Int
            let page:Int
            let page_count:Int
            let page_size:Int
            let products: [Products]
            let skip:Int
        }
        
        
        struct Products: Codable {
            let code:String
            let product_name:String
        }
        
        let task = URLSession.shared.dataTask(with: URL(string:url)!, completionHandler:{ data,response,error in
            guard let data = data, error == nil else{
                print("erreur")
                return
            }
            
            //Have data
            var result:Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch{
                print("Erreur decodage API \(error)")
            }
            guard let json = result else{
                return
            }
            
            
            
            self.produit = json.products[0].product_name
            
            print("Le produit trouver est \(self.produit)")
            var ingre = "";
            for ingredient in self.listeIngredient
            {
                if self.produit.lowercased().contains(ingredient) {
                    ingre = ingredient
                }
            }
            
            print("l'ingredient trouver est\(ingre)")

            if(self.produit == "")
            {
                return;
            }
            self.getMeal(ingredient: ingre)
        })
        task.resume()
    }
    
    func getMeal(ingredient:String)
    {
        
        let url = "https://www.themealdb.com/api/json/v1/1/filter.php?i=\(ingredient)";
        
        struct Response:Codable {
            let meals:[Meal];
        }
        
        struct Meal: Codable{
            let strMeal:String
            let strMealThumb:String
            let idMeal:String
        }
        
        let task = URLSession.shared.dataTask(with: URL(string:url)!, completionHandler:{ data,response,error in
            guard let data = data, error == nil else{
                print("erreur")
                return
            }
            
            //Have data
            var result:Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch{
                print("Erreur decodage API \(error)")
            }
            guard let json = result else{
                return
            }
                        
            for plat in json.meals {
                let platRecup = Plat(id: plat.idMeal, nom: plat.strMeal, image: plat.strMealThumb)
                self.listPlat.append(platRecup);
                print(platRecup.description)
                print(self.listPlat.description)
            }
            
        })
        task.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "retour" {
            let destinationVC = segue.destination as! AccueilViewController
            
            destinationVC.listDefinitiveDePlat = self.listPlat
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}
