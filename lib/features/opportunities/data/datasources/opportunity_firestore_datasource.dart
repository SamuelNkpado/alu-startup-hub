import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/opportunity_model.dart';

class OpportunityFirestoreDataSource {
  final FirebaseFirestore firestore;

  OpportunityFirestoreDataSource(this.firestore);

  CollectionReference get _collection => firestore.collection('opportunities');

  Stream<List<OpportunityModel>> watchOpenOpportunities() {
    return _collection
        .where('status', isEqualTo: 'open')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => OpportunityModel.fromFirestore(doc)).toList());
  }

  Future<OpportunityModel> getById(String id) async {
    final doc = await _collection.doc(id).get();
    return OpportunityModel.fromFirestore(doc);
  }

  Future<void> create(OpportunityModel model) async {
    await _collection.doc(model.id).set(model.toFirestore());
  }

  Future<void> update(OpportunityModel model) async {
    await _collection.doc(model.id).update(model.toFirestore());
  }

  Future<void> close(String id) async {
    await _collection.doc(id).update({'status': 'closed'});
  }
}