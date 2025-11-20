import express from 'express'
import { verifyToken } from '../middleware/authMiddleware.js';
import {createIssue , getIssuesByProject , getIssuesByAssignee } from "../controllers/issue.controller.js";
import {assignUserToIssue , updateIssue  , deleteIssue } from  "../controllers/issue.controller.js";
const route = express.Router();

//CRUD
route.post("/", verifyToken , createIssue);
route.get("/", verifyToken, getIssuesByProject);
route.put("/:issueId" , verifyToken , updateIssue );
route.delete('/:issueId' , verifyToken , deleteIssue );


//
route.get("/assignee/:assigneeId", verifyToken, getIssuesByAssignee);
route.put("/:issueId/assign", verifyToken, assignUserToIssue);


export default route;