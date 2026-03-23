import { useEffect, useState } from "react";
import { Link } from "react-router-dom";

interface Task {
  id: string;
  title: string;
  status: string;
  priority: string;
}

export function TaskList() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch("/api/v1/tasks")
      .then((r) => r.json())
      .then((data) => {
        setTasks(data.tasks || []);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  if (loading) return <p>Loading...</p>;

  return (
    <div>
      <h2>Tasks</h2>
      {tasks.length === 0 ? (
        <p>No tasks yet.</p>
      ) : (
        <ul style={{ listStyle: "none", padding: 0 }}>
          {tasks.map((t) => (
            <li key={t.id} style={{ padding: "0.75rem", borderBottom: "1px solid #eee" }}>
              <Link to={`/tasks/${t.id}`} style={{ fontWeight: 600, color: "#2563eb" }}>
                {t.title}
              </Link>
              <div style={{ fontSize: "0.85rem", color: "#888", marginTop: "0.25rem" }}>
                {t.status} &middot; {t.priority}
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
