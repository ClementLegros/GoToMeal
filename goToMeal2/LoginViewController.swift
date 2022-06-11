import UIKit

import CoreData



class LoginViewController: UIViewController, UITextFieldDelegate

{

    var goToMeal2 : [NSManagedObject] = []



    

    @IBOutlet weak var connexion: UIButton!

    

    @IBOutlet weak var mail: UITextField!

    

    @IBOutlet weak var mdp: UITextField!

    var prenom = "test7485458";

    

    

    override func viewDidLoad()

    {

        mail.delegate = self

        mdp.delegate = self

        

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate

        else

        {

            return

        }

        

        let managedContext = appDelegate.persistentContainer.viewContext



        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Utilisateur")

        

        do

        {

            goToMeal2 = try managedContext.fetch(fetchRequest)

            print(goToMeal2)

        }

        catch let error as NSError

        {

        

            print("Erreur lors de la récupération des données \(error),\(error.userInfo)")

        }

    }

    

    /* Retour en arrière depuis la page Accueil */

    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue){

        print("Unwind segue ok")

    }

    

    /* Retour en arrière depuis la page Inscription */

    @IBAction func myUnwindActionInsc(unwindSegue: UIStoryboardSegue){

        print("Unwind segue ok")

    }



    func textFieldDidChangeSelection(_ textField: UITextField)

    {

        if (mdp.text != "" && mail.text != "") {

            connexion.isEnabled = true

        }

    }

    

    

    

  

    @IBAction func connexion(_ sender: Any) {

        print(goToMeal2)

        for Utilisateur in goToMeal2

       {

            

            if mail.text! == (Utilisateur.value(forKeyPath: "mail") as! String) && mdp.text! == (Utilisateur.value(forKeyPath: "motDePasse") as! String)

            {

                print("La connexion se fait ici")

                prenom = (Utilisateur.value(forKeyPath: "prenom") as! String)

                print(prenom)

                performSegue(withIdentifier: "DeVueConnexionVersVueAccueil", sender: nil)

            }

            else{

                let dialogMessage = UIAlertController(title: "Confirm", message: "Mail ou mot de passe incorrect.", preferredStyle: .alert)

                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in

                    print("Ok button tapped")

                })

                dialogMessage.addAction(ok)

                self.present(dialogMessage, animated: true, completion: nil)

            }

        }

    }

    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool

    {

        mail.resignFirstResponder()

        mdp.resignFirstResponder()

        return true;

    }

    

    

    override func prepare(for segue: UIStoryboardSegue,sender: Any?)

    {

        

        if segue.identifier == "DeVueConnexionVersVueAccueil"

        {

            // Definition du controler de destinatation

            let destinationVC = segue.destination as! AccueilViewController

            

            destinationVC.username = prenom;

            destinationVC.modalPresentationStyle = .fullScreen

        }

        if segue.identifier == "DeVueConnexionVersVueInscription"

        {

            // Definition du controler de destinatation

            let destinationVC = segue.destination as! ViewController

            destinationVC.modalPresentationStyle = .fullScreen

        }

    }

}
