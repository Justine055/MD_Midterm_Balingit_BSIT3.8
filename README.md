MD\_Midterm\_Balingit\_BSIT3.8



Application Title



Community Learning Center Management System



Description

&#x09;This application is a simple command-line system written in Dart for managing a Community Learning Center. It helps track available learning resources (like books or hardware), register participants, process resource loans and returns, and log transaction history.

&#x09;I built this project to demonstrate core Dart concepts and Object-Oriented Programming (OOP) principles like abstract classes, inheritance, polymorphism, encapsulation, mixins, error handling, and collection management using Lists and Maps.



Features Implemented

* Console Interface \& Navigation: Interactive main menu built with standard input/output operations (stdin and stdout) running inside a continuous execution loop.
* Error Handling \& Input Validation: Menu choices and user entries are validated with try-catch blocks and condition checks to prevent crashes when invalid choices or bad data formats are entered.
* Classes \& Encapsulation: Private fields (\_id, \_name, etc.) guarded by custom getters and setters.
* Inheritance \& Abstraction: Base abstract class CenterRecord extended by concrete subclasses LearningResource and Participant.
* Polymorphism: Unified record printing using dynamic method overriding (printDetails()) across different subclass instances.
* Mixins: PrintableRecord mixin attached to center records to generate standard timestamps and print formats.
* Collections \& Audit Logs: Fast lookups using Map<String, LearningResource> and Map<String, Participant>, with active transactions recorded sequentially inside a List<String>.



Sample Test Scenarios

Test 1: Registering a Resource and Participant

* Select option 1 from the main menu.
* Enter ID: RES-003, Title: Cloud Architecture Fundamentals, Category: Technology, Copies: 4.
* Select option 2 from the main menu.
* Enter ID: PAR-103, Name: Angelica Cruz, Contact: 09223344556, Membership: Teacher.
* Result: Both records are created without errors and properly displayed when choosing Option 3 (View All Records).



Test 2: Borrowing and Returning Items

* Select option 4 (Process Transaction) -> Select 1 (Borrow).
* Input Participant ID: PAR-101 and Resource ID: RES-001.
* Result: Available copies for RES-001 drop from 3 to 2, RES-001 is added under PAR-101's active loan list, and an entry is added to audit logs (Option 5).
* Select option 4 -> Select 2 (Return) using the same IDs to return the item.
* Result: Available copy count increases back to 3, and the item ID is removed from the participant's active list.



Test 3: Handling Invalid Input

* Enter letters (abc) or special characters when prompted for menu selection.
* Attempt to register a resource with a non-numeric copy count.
* Try borrowing a resource using an invalid Participant ID (PAR-999).
* Result: The application displays clear error warnings (e.g., \[Input Exception Error] or \[Error] Participant ID not found) and returns safely to the main menu without crashing.



Running the Application

* Make sure you have the Dart SDK installed on your system.
* Open your terminal or command prompt inside the project folder.
* Run the following command:
* dart run main.dart





AI Use Declaration

* AI Tool Used: Google Gemini
* Purpose: Used for clarifying Dart syntax nuances (specifically mixin integration), refining terminal output layout formatting, and double-checking exception handling logic.
* Scope: AI assistance was kept under 20%. Program architecture, class design, data flows, validation checks, and code testing were independently written and verified.

