import { Link, Outlet } from "react-router-dom";

export function App() {
  return (
    <div style={{ maxWidth: 960, margin: "0 auto", padding: "1rem" }}>
      <header style={{ borderBottom: "1px solid #eee", paddingBottom: "1rem", marginBottom: "1rem" }}>
        <h1 style={{ margin: 0 }}>
          <Link to="/" style={{ textDecoration: "none", color: "#111" }}>
            E2E Test Workspace
          </Link>
        </h1>
        <p style={{ color: "#666", margin: "0.25rem 0 0" }}>Flutter + React + Go</p>
      </header>
      <main>
        <Outlet />
      </main>
    </div>
  );
}
