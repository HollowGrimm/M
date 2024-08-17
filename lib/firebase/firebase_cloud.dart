import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../services/singleton.dart';

class FirebaseCloud {
  final firestore = FirebaseFirestore.instance;
  final singleton = Singleton();

  String generateUUID() {
    return const Uuid().v4();
  }

  Future<void> createUser(
      String? userId,
      String username,
      String bio,
      String profilePic,
      List<String> ideas,
      List<String> published,
      List<String> comments) async {
    DocumentSnapshot existingDoc =
        await firestore.collection('user').doc(userId).get();
    if (existingDoc.exists) {
    } else {
      try {
        await firestore.collection('user').doc(userId).set({
          'username': username,
          'bio': bio,
          'comments': comments,
          'profilePic': profilePic,
          'ideasList': ideas,
          'publishedList': published,
        });
      } catch (e) {
        print('Error creating user: $e');
      }
    }
  }

  Future<List<String>> getList(listName) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(await singleton.getUID())
          .get();

      if (documentSnapshot.exists) {
        // Perform actions with the data
        print('Document ID: ${documentSnapshot.id}');
        return ((documentSnapshot.data() as Map<String, dynamic>)[listName]
                as List<dynamic>)
            .map((dynamic item) => item.toString())
            .toList();
      } else {
        print('Document with ID testuser1 does not exist.');
      }
    } catch (e) {
      print('Error: $e');
    }
    return [];
  }

  Future<void> getUser(userID) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('user').doc(userID).get();

      if (documentSnapshot.exists) {
        singleton.updateProfile(documentSnapshot.get('profilePic'),
            documentSnapshot.get('username'), documentSnapshot.get('bio'));

        singleton.setUserCommentIDs(await getList('comments'));
        singleton.setUserpublishedIDs(await getList('publishedList'));
        singleton.setUserIdeasIDs(await getList('ideasList'));

        // Perform actions with the data
        print('Document ID: ${documentSnapshot.id}');
      } else {
        print('Document with ID testuser1 does not exist.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateUser(
    String userId,
    String username,
    String bio,
    String profilePic,
  ) async {
    try {
      // Reference to the Firestore document
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('user').doc(userId);

      // Create a map of fields to update
      Map<String, dynamic> updatedFields = {
        'bio': bio,
        'profilePic': profilePic,
        'username': username
      };

      // Update the fields in the document
      await documentReference.update(updatedFields);
      await updateAuthor(username);

      print('Document with ID $userId updated successfully.');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateAuthor(String username) async {
    for (var id in singleton.userIdeasIDs) {
      try {
        // Reference to the Firestore document
        DocumentReference documentReference =
            FirebaseFirestore.instance.collection('ideas_published').doc(id);

        // Create a map of fields to update
        Map<String, dynamic> updatedFields = {'username': username};

        // Update the fields in the document
        await documentReference.update(updatedFields);

        print('Document with ID $id updated successfully.');
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> createWriting(String feedback, String modifiedDate, published,
      String story, String title, String username) async {
    String documentID = generateUUID();
    updateDocumentIDList(
        'user', await singleton.getUID(), 'ideasList', documentID);
    if (published) {
      updateDocumentIDList(
          'user', await singleton.getUID(), 'publishedList', documentID);
    }
    updateDocumentIDList('user', await singleton.getUID(),
        published ? 'publishedList' : 'ideasList', documentID);
    DocumentSnapshot existingDoc =
        await firestore.collection('ideas_published').doc(documentID).get();
    if (existingDoc.exists) {
    } else {
      try {
        await firestore.collection('ideas_published').doc(documentID).set({
          'comments': [],
          'feedback': feedback,
          'modifiedDate': modifiedDate,
          'published': published,
          'story': story,
          'title': title,
          'username': username
        });
      } catch (e) {
        print('Error creating user: $e');
      }
    }
  }

  Future<void> getWriting(documentID, bool published) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('ideas_published')
          .doc(documentID)
          .get();

      if (documentSnapshot.exists) {
        List<String> tempList = [
          documentSnapshot.get('title'),
          documentSnapshot.get('username'),
          documentSnapshot.get('modifiedDate'),
          documentSnapshot.get('story'),
          documentSnapshot.get('feedback')
        ];
        if (published) {
          singleton.setPublished(tempList);
        } else {
          singleton.setIdea(tempList);
        }
        // Perform actions with the data
        print('Document ID: ${documentSnapshot.id}');
      } else {
        print('Document with ID $documentID does not exist.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateWriting(
      documentId, feedback, modifiedDate, published, story, title) async {
    try {
      // Reference to the Firestore document
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('ideas_published')
          .doc(documentId);

      // Create a map of fields to update
      Map<String, dynamic> updatedFields = {
        'feedback': feedback,
        'modifiedDate': modifiedDate,
        'published': published,
        'story': story,
        'title': title,
      };

      // Update the fields in the document
      await documentReference.update(updatedFields);

      print('Document with ID $documentId updated successfully.');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> createComment(postID, comment) async {
    String documentID = generateUUID();
    updateDocumentIDList(
        'user', await singleton.getUID(), 'comments', documentID);
    updateDocumentIDList('ideas_published', postID, 'comments', documentID);
    DocumentSnapshot existingDoc =
        await firestore.collection('comments').doc(documentID).get();
    if (existingDoc.exists) {
    } else {
      try {
        await firestore.collection('comments').doc(documentID).set({
          'likes': 0,
          'comment': comment,
        });
      } catch (e) {
        print('Error creating user: $e');
      }
    }
  }

  Future<void> updateLikes(documentId, likes) async {
    try {
      // Reference to the Firestore document
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection('comments').doc(documentId);

      // Create a map of fields to update
      Map<String, dynamic> updatedFields = {
        'likes': likes,
      };

      // Update the fields in the document
      await documentReference.update(updatedFields);

      print('Document with ID $documentId updated successfully.');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateDocumentIDList(
      String collection, String documentId, String listName, String id) async {
    DocumentReference docRef = firestore.collection(collection).doc(documentId);

    try {
      await docRef.update({
        listName: FieldValue.arrayUnion([id])
      });

      print('Field updated successfully.');
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  Future<void> deleteDocument(String collectionName, String documentId) async {
    // Reference to the Firestore document you want to delete
    print("Deleting Document ID: $documentId");
    DocumentReference docReference =
        FirebaseFirestore.instance.collection(collectionName).doc(documentId);

    try {
      // Use the delete method to delete the document
      await docReference.delete();
      print('Document deleted successfully.');
    } catch (e) {
      print('Error deleting document: $e');
    }
  }
}
