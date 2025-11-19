import express from 'express'
import { verifyToken } from '../middleware/authMiddleware.js';
import {createIssue , getIssuesByProject , getIssuesByAssignee } from "../controllers/issue.controller.js";

const route = express.Router();


route.post("/", verifyToken , createIssue);
route.get("/", verifyToken, getIssuesByProject);

route.get("/assignee/:assigneeId", verifyToken, getIssuesByAssignee);

export default route;