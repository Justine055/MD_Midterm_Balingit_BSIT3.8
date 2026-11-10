import 'dart:io';

mixin PrintableRecord {
  String getTimestamp() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
           "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  void printDetails();
}

abstract class CenterRecord with PrintableRecord {
  String _id;
  String _name;
  
  CenterRecord(this._id, this._name);

  String get id => _id;
  String get name => _name;

  set id(String newId) {
    if (newId.trim().isNotEmpty) {
      _id = newId;
    }
  }

  set name(String newName) {
    if (newName.trim().isNotEmpty) {
      _name = newName;
    }
  }

  @override
  void printDetails();
}

class LearningResource extends CenterRecord {
  String _category;
  int _totalCopies;
  int _availableCopies;

  LearningResource(String id, String name, this._category, int totalCopies)
      : _totalCopies = totalCopies,
        _availableCopies = totalCopies,
        super(id, name);

  String get category => _category;
  int get totalCopies => _totalCopies;
  int get availableCopies => _availableCopies;

  bool borrowResource() {
    if (_availableCopies > 0) {
      _availableCopies--;
      return true;
    }
    return false;
  }

  bool returnResource() {
    if (_availableCopies < _totalCopies) {
      _availableCopies++;
      return true;
    }
    return false;
  }

  @override
  void printDetails() {
    print("--------------------------------------------------");
    print(" [Resource ID]   : $id");
    print(" [Title]         : $name");
    print(" [Category]      : $_category");
    print(" [Copies Status] : $_availableCopies / $_totalCopies available");
    print(" [Logged On]     : ${getTimestamp()}");
    print("--------------------------------------------------");
  }
}

class Participant extends CenterRecord {
  String _contactNumber;
  String _membershipType;
  final List<String> _borrowedResourceIds = [];

  Participant(String id, String name, this._contactNumber, this._membershipType)
      : super(id, name);

  String get contactNumber => _contactNumber;
  String get membershipType => _membershipType;
  List<String> get borrowedResourceIds => _borrowedResourceIds;

  void addBorrowedResource(String resourceId) {
    _borrowedResourceIds.add(resourceId);
  }

  void removeBorrowedResource(String resourceId) {
    _borrowedResourceIds.remove(resourceId);
  }

  @override
  void printDetails() {
    print("--------------------------------------------------");
    print(" [Participant ID]: $id");
    print(" [Full Name]     : $name");
    print(" [Contact #]     : $_contactNumber");
    print(" [Membership]    : $_membershipType");
    print(" [Active Loans]  : ${_borrowedResourceIds.length} item(s) -> ${_borrowedResourceIds}");
    print(" [Registered At] : ${getTimestamp()}");
    print("--------------------------------------------------");
  }
}

void main() {
  final Map<String, LearningResource> resourceMap = {};
  final Map<String, Participant> participantMap = {};
  final List<String> transactionLogs = [];

  resourceMap['RES-001'] = LearningResource('RES-001', 'Dart & Flutter Programming Guide', 'Technology', 3);
  resourceMap['RES-002'] = LearningResource('RES-002', 'Introduction to Cybersecurity', 'Technology', 2);
  
  participantMap['PAR-101'] = Participant('PAR-101', 'Juan Dela Cruz', '09123456789', 'Student');
  participantMap['PAR-102'] = Participant('PAR-102', 'Maria Santos', '09987654321', 'Community Member');

  bool isRunning = true;

  print("\n==================================================");
  print(" COMMUNITY LEARNING CENTER MANAGEMENT SYSTEM");
  print(" Mobile Development Midterm Laboratory Examination");
  print("==================================================");

  while (isRunning) {
    print("\n--- MAIN MENU ---");
    print("[1] Register New Learning Resource");
    print("[2] Register New Participant");
    print("[3] View All Records (Polymorphic Display)");
    print("[4] Process Resource Borrow / Return Transaction");
    print("[5] View Transaction Audit Logs");
    print("[6] Exit Application");
    stdout.write("Enter your choice (1-6): ");

    try {
      String? input = stdin.readLineSync();
      if (input == null) continue;
      
      int choice = int.parse(input.trim());

      switch (choice) {
        case 1:
          _registerResource(resourceMap);
          break;
        case 2:
          _registerParticipant(participantMap);
          break;
        case 3:
          _viewAllRecords(resourceMap, participantMap);
          break;
        case 4:
          _processTransaction(resourceMap, participantMap, transactionLogs);
          break;
        case 5:
          _viewLogs(transactionLogs);
          break;
        case 6:
          isRunning = false;
          print("\nExiting system. Thank you for using the Community Learning Center Management System!");
          break;
        default:
          print("\n[Error] Invalid menu option selected. Please choose a number between 1 and 6.");
      }
    } catch (e) {
      print("\n[Input Exception Error]: Invalid input format detected. Please enter a valid integer choice.");
    }
  }
}

void _registerResource(Map<String, LearningResource> resources) {
  print("\n--- Register Learning Resource ---");
  stdout.write("Enter Resource ID (e.g., RES-003): ");
  String id = stdin.readLineSync()?.trim() ?? "";
  
  if (id.isEmpty || resources.containsKey(id)) {
    print("[Error] Resource ID cannot be empty or already exists.");
    return;
  }

  stdout.write("Enter Resource Title: ");
  String title = stdin.readLineSync()?.trim() ?? "";
  if (title.isEmpty) {
    print("[Error] Resource title cannot be blank.");
    return;
  }

  stdout.write("Enter Category (e.g., Technology, Science, Arts): ");
  String category = stdin.readLineSync()?.trim() ?? "General";

  stdout.write("Enter Total Number of Copies: ");
  int? copies = int.tryParse(stdin.readLineSync()?.trim() ?? "");
  
  if (copies == null || copies <= 0) {
    print("[Error] Invalid copy count. Must be a positive integer.");
    return;
  }

  resources[id] = LearningResource(id, title, category, copies);
  print("\n[Success] Learning resource '$title' successfully registered.");
}

void _registerParticipant(Map<String, Participant> participants) {
  print("\n--- Register Participant ---");
  stdout.write("Enter Participant ID (e.g., PAR-103): ");
  String id = stdin.readLineSync()?.trim() ?? "";

  if (id.isEmpty || participants.containsKey(id)) {
    print("[Error] Participant ID cannot be empty or already exists.");
    return;
  }

  stdout.write("Enter Full Name: ");
  String name = stdin.readLineSync()?.trim() ?? "";
  if (name.isEmpty) {
    print("[Error] Participant name cannot be blank.");
    return;
  }

  stdout.write("Enter Contact Number: ");
  String contact = stdin.readLineSync()?.trim() ?? "N/A";

  stdout.write("Enter Membership Type (Student/Teacher/Member): ");
  String membership = stdin.readLineSync()?.trim() ?? "Member";

  participants[id] = Participant(id, name, contact, membership);
  print("\n[Success] Participant '$name' successfully registered.");
}

void _viewAllRecords(Map<String, LearningResource> resources, Map<String, Participant> participants) {
  print("\n==================================================");
  print(" POLYMORPHIC RECORDS AUDIT VIEW");
  print("==================================================");

  print("\n--- LEARNING RESOURCES (${resources.length}) ---");
  if (resources.isEmpty) {
    print("No resources recorded.");
  } else {
    resources.values.forEach((CenterRecord record) {
      record.printDetails();
    });
  }

  print("\n--- REGISTERED PARTICIPANTS (${participants.length}) ---");
  if (participants.isEmpty) {
    print("No participants recorded.");
  } else {
    participants.values.forEach((CenterRecord record) {
      record.printDetails();
    });
  }
}

void _processTransaction(
    Map<String, LearningResource> resources,
    Map<String, Participant> participants,
    List<String> logs) {
  print("\n--- Process Borrow / Return Transaction ---");
  print("[1] Borrow Resource");
  print("[2] Return Resource");
  stdout.write("Select transaction type (1 or 2): ");
  
  String? choiceInput = stdin.readLineSync()?.trim();
  if (choiceInput != '1' && choiceInput != '2') {
    print("[Error] Invalid transaction choice.");
    return;
  }

  stdout.write("Enter Participant ID: ");
  String pId = stdin.readLineSync()?.trim() ?? "";
  if (!participants.containsKey(pId)) {
    print("[Error] Participant ID '$pId' not found in system records.");
    return;
  }

  stdout.write("Enter Resource ID: ");
  String rId = stdin.readLineSync()?.trim() ?? "";
  if (!resources.containsKey(rId)) {
    print("[Error] Resource ID '$rId' not found in system records.");
    return;
  }

  Participant participant = participants[pId]!;
  LearningResource resource = resources[rId]!;
  final now = DateTime.now();
  String timestampStr = "${now.hour}:${now.minute}:${now.second}";

  if (choiceInput == '1') {
    if (resource.borrowResource()) {
      participant.addBorrowedResource(rId);
      String log = "[$timestampStr] BORROW: ${participant.name} borrowed '${resource.name}'";
      logs.add(log);
      print("\n[Success] Transaction complete! ${participant.name} successfully borrowed '${resource.name}'.");
    } else {
      print("\n[Transaction Failed] Zero copies available for '${resource.name}'.");
    }
  } else {
    if (participant.borrowedResourceIds.contains(rId)) {
      resource.returnResource();
      participant.removeBorrowedResource(rId);
      String log = "[$timestampStr] RETURN: ${participant.name} returned '${resource.name}'";
      logs.add(log);
      print("\n[Success] Transaction complete! ${participant.name} successfully returned '${resource.name}'.");
    } else {
      print("\n[Transaction Failed] Record mismatch: Participant has not borrowed this specific resource.");
    }
  }
}

void _viewLogs(List<String> logs) {
  print("\n==================================================");
  print(" SYSTEM TRANSACTION AUDIT LOGS");
  print("==================================================");
  if (logs.isEmpty) {
    print("No transactions have been processed yet.");
  } else {
    for (int i = 0; i < logs.length; i++) {
      print("${i + 1}. ${logs[i]}");
    }
  }
}