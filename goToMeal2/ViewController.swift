import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var champNom: UITextField!
    @IBOutlet weak var champPrenom: UITextField!
    @IBOutlet weak var champMail: UITextField!
    @IBOutlet weak var champMotDePasse: UITextField!
    @IBOutlet weak var buttonInscription: UIButton!
    
    var goToMeal2 : [NSManagedObject] = []
     
    override func viewDidLoad()
    {
        champNom.delegate = self
        champPrenom.delegate = self
        champMail.delegate = self
        champMotDePasse.delegate = self
        super.viewDidLoad()
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField)
    {
        if(isValidEmail(email: champMail.text!))
        {
            print("Email correct")
            if (champNom.text != "" && champPrenom.text != "" && champMail.text != "" && champMotDePasse.text != "")
            {
                buttonInscription.isEnabled = true
            }
        }
        else
        {
            print("Email incorrect")
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    @IBAction func save(_ sender: Any)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else
        {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let utilisateur = Utilisateur.init(entity: NSEntityDescription.entity(forEntityName: "Utilisateur", in:managedContext)!,insertInto: managedContext)
        // Sauvegarde des données
        utilisateur.setValue(champNom.text ?? "", forKeyPath: "nom")
        utilisateur.setValue(champPrenom.text ?? "", forKeyPath: "prenom")
        utilisateur.setValue(champMail.text ?? "", forKeyPath: "mail")
        utilisateur.setValue(champMotDePasse.text ?? "", forKeyPath: "motDePasse")
        do
        {
            try managedContext.save()
            goToMeal2.append(utilisateur)
        }
        catch let error as NSError
        {
            print("Erreur d'enregistrement :  \(error), \(error.userInfo)")
        }
             
        champNom.text = nil
        champMail.text = nil
        champPrenom.text = nil
        champMotDePasse.text = nil
    }
}

