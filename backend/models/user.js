import { db } from "../config/db.js";
import admin from "firebase-admin";

export class User {
  constructor({
    uid = null,
    firstName = "",
    lastName = "",
    userName = "",
    email,
    role = "member",
    status = "active",
    photoUrl = "",
    friends = [],
    createdAt = admin.firestore.FieldValue.serverTimestamp(),
    updatedAt = admin.firestore.FieldValue.serverTimestamp(),
  }) {
    this.uid = uid;                  
    this.firstName = firstName;
    this.lastName = lastName;
    this.userName = userName;
    this.email = email;
    this.role = role;
    this.status = status;
    this.photoUrl = photoUrl;
    this.friends = friends;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }


  async save() {
    if (!this.email) throw new Error("Email is required");

    const payload = {
      uid: this.uid,
      firstName: this.firstName,
      lastName: this.lastName,
      userName: this.userName,
      email: this.email,
      role: this.role,
      status: this.status,
      photoUrl: this.photoUrl,
      friends: this.friends,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };

    const ref = db.collection("users").doc();

    await ref.set({ ...payload, uid: ref.id });

    this.uid = ref.id;

    return this;
  }

static async searchByEmail(emailQuery, limit = 10) {
  if (!emailQuery) return [];
  emailQuery = emailQuery.toLowerCase();
  const snapshot = await db
    .collection("users")
    .orderBy("email")
    .startAt(emailQuery)
    .endAt(emailQuery + '\uf8ff')  
    .limit(limit)
    .get();

  return snapshot.docs.map(doc => doc.data());
}

static async getById(userId) {
    const docRef = db.collection("users").doc(userId);
    const docSnap = await docRef.get();
    
    if (!docSnap.exists) {
      return null;
    }
    return docSnap.data();
  }
}
  
