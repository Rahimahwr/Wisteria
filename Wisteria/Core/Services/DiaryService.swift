import FirebaseFirestore
import FirebaseAuth

class DiaryService {
    static let shared = DiaryService()
    private let db = Firestore.firestore()
    
    func saveEntry(mood: String, conditions: [String], products: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let entry = DiaryEntry(
            userId: uid,
            timestamp: Date(), // Current time
            mood: mood,
            conditions: conditions,
            products: products
        )
        
        try db.collection("diary_entries").addDocument(from: entry)
    }
    
    func fetchEntries() async throws -> [DiaryEntry] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        
        let snapshot = try await db.collection("diary_entries")
            .whereField("userId", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: DiaryEntry.self) }
    }
}