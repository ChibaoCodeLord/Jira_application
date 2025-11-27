// controllers/comment.controller.js
import { db } from "../config/db.js";
import { sendSuccessResponse, sendErrorResponse } from "../utils/response.js";

const commentsCollection = db.collection("comments");

export const getCommentByTask = async (req, res) => {
    const { idTask } = req.params; 
    try {
      const snapshot = await commentsCollection
        .where("taskId", "==", idTask)
        .orderBy("createdAt", "desc")
        .get();
  
      const comments = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
      return sendSuccessResponse(res, 200, "Comments fetched successfully", comments);
    } catch (error) {
      return sendErrorResponse(res, 500, error.message, "Failed to fetch comments");
    }
  };
  
  export const createComment = async (req, res) => {
    const { idTask } = req.params;
    const { content } = req.body;
    const { id: userId, username, email } = req.user;
  
    try {
      const newComment = {
        taskId: idTask,
        userId,
        content,
        username: username || null,
        email: email || null,
        createdAt: new Date(),
      };
  
      const docRef = await commentsCollection.add(newComment);
      return sendSuccessResponse(res, 201, "Comment created successfully", { id: docRef.id, ...newComment });
    } catch (error) {
      return sendErrorResponse(res, 500, error.message, "Failed to create comment");
    }
  };
  
  export const removeComment = async (req, res) => {
    const { idComment } = req.params;
    try {
      const docRef = commentsCollection.doc(idComment);
      const doc = await docRef.get();
  
      if (!doc.exists) {
        return sendErrorResponse(res, 404, null, "Comment not found");
      }
  
      await docRef.delete();
      return sendSuccessResponse(res, 200, "Comment deleted successfully", { id: idComment });
    } catch (error) {
      return sendErrorResponse(res, 500, error.message, "Failed to delete comment");
    }
  };
  