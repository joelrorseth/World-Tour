import UIKit

public class GATableViewController: UITableViewController {
    
    var tours = [Tour]()
    public var algorithm: PnPGeneticAlgorithm?
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell id and title
        self.title = "Genetic Simulation"
        
        // Set navigation bar buttons
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Run",
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(runClicked))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: nil)
    }

    // Begin the visual genetic algorithm evolution, updating in the contained UITableViewController
    @objc public func runClicked() {

        if let algorithm = algorithm {
            
            DispatchQueue.global(qos: .background).async {
                _ = algorithm.simulateNGenerations()
            }

        } else { print("Error: Must set GANavigationController's algorithm property") }
    }
}

// MARK: SimulationDelegate methods
extension GATableViewController: SimulationDelegate {
    
    public func yieldNewGeneration(fittest: Tour) {
        
        DispatchQueue.main.async {
        
            // Add this new tour to the Tour list
            self.tours.append(fittest)
            
            // Dynamically update table view
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: self.tours.count-1, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
    }
}


// MARK: UITableViewController delegate methods
extension GATableViewController {
    
    public override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            
            // Dequeue a new cell
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
        }
        
        // Display Tour information
        cell.textLabel?.text = "\(tours[indexPath.row].totalDistance) km"
        
        if (indexPath.row == 0) {
            cell.detailTextLabel?.text = "Initial population"
        } else {
            cell.detailTextLabel?.text = "Generation \(indexPath.row)"
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        
        return tours.count
    }
    
    public override func tableView(_ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        
        let tour = tours[indexPath.row]
        
        // Show controller with expanded view of the sequence
        let viewController = SequenceViewController(
            frame: tableView.frame, tour: tour, generation: indexPath.row)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
