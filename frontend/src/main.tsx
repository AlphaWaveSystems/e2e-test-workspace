import React from "react";
import ReactDOM from "react-dom/client";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { App } from "./App";
import { TaskList } from "./pages/TaskList";
import { TaskDetail } from "./pages/TaskDetail";

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<App />}>
          <Route index element={<TaskList />} />
          <Route path="tasks/:id" element={<TaskDetail />} />
        </Route>
      </Routes>
    </BrowserRouter>
  </React.StrictMode>
);
