// Isssue Model
export const Issue = {
    id: "",
    projectId: "",
    title: "",
    summary: "",
    description: "",
    type: "task",
    priority: "Low",
    status: "todo",

    assigneeId: null,
    reporterId: null,

    parentId: null,      
    subTasks: [],      

    createdAt: Date.now(),
    updatedAt: Date.now(),
}
