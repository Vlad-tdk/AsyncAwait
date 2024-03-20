//
//  ViewController.swift
//  AsyncAwait
//
//  Created by Vlad on 20.3.24..
//

import UIKit

final class CoursesViewController: UITableViewController {
    
    var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        showCourses()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CourseCell
        let course = courses[indexPath.row]
        cell.configure(with: course)
        return cell
    }

    /*
    private func showCourses() {
        NetworkManager.shared.fetchCourses { result in
            switch result {
            case .success(let courses):
                self.courses = courses
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    */
    
    /*
    private func showCourses() {
        Task {
            do {
                courses = try await NetworkManager.shared.fetchCourses()
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    */
    
    private func showCourses() {
        Task {
            do {
                courses = try await NetworkManager.shared.fetchCoursesWithContinuation()
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

