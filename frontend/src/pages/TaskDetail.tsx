import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";

interface Task {
  id: string;
  title: string;
  description: string;
  status: string;
  priority: string;
  createdAt: string;
}

export function TaskDetail() {
  const { id } = useParams<{ id: string }>();
  const [task, setTask] = useState<Task | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch(`/api/v1/tasks/${id}`)
      .then((r) => r.json())
      .then((data) => {
        setTask(data.task || null);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, [id]);

  if (loading) return <p>Loading...</p>;
  if (!task) return <p>Task not found.</p>;

  return (
    <div>
      <Link to="/" style={{ color: "#2563eb" }}>&larr; Back</Link>
      <h2>{task.title}</h2>
      <p>{task.description}</p>
      <p>
        <strong>Status:</strong> {task.status} &middot;
        <strong> Priority:</strong> {task.priority}
      </p>
      <p style={{ fontSize: "0.85rem", color: "#888" }}>
        Created: {new Date(task.createdAt).toLocaleString()}
      </p>
    </div>
  );
}
