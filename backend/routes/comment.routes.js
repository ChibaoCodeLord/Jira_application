import express, { Router } from 'express'
//authentication 
import { verifyToken } from '../middleware/authMiddleware.js';

//import controller 
import {
    createComment , getCommentByTask , removeComment
} from "../controllers/comment.controller.js";

const route = Router()

route.get('/:idTask', verifyToken, getCommentByTask);     
route.post('/:idTask', verifyToken, createComment);

route.delete('/:idComment', verifyToken, removeComment);    


export default route ;


