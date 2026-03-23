package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/go-chi/cors"
)

type HealthResponse struct {
	Status    string `json:"status"`
	Timestamp string `json:"timestamp"`
	Version   string `json:"version"`
}

type Task struct {
	ID          string `json:"id"`
	Title       string `json:"title"`
	Description string `json:"description"`
	Status      string `json:"status"`
	Priority    string `json:"priority"`
	CreatedAt   string `json:"createdAt"`
}

var tasks = []Task{
	{ID: "1", Title: "Set up CI/CD pipeline", Description: "Configure GitHub Actions for all three stacks", Status: "backlog", Priority: "high", CreatedAt: time.Now().Format(time.RFC3339)},
	{ID: "2", Title: "Add authentication", Description: "JWT-based auth with refresh tokens", Status: "backlog", Priority: "critical", CreatedAt: time.Now().Format(time.RFC3339)},
	{ID: "3", Title: "Database migrations", Description: "Set up PostgreSQL schema and migration tooling", Status: "backlog", Priority: "high", CreatedAt: time.Now().Format(time.RFC3339)},
}

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	r := chi.NewRouter()

	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.RequestID)
	r.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"http://localhost:5173", "http://localhost:3000"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type"},
		AllowCredentials: true,
	}))

	// Routes
	r.Get("/health", handleHealth)
	r.Route("/api/v1", func(r chi.Router) {
		r.Get("/tasks", handleListTasks)
		r.Get("/tasks/{id}", handleGetTask)
		r.Post("/tasks", handleCreateTask)
		r.Patch("/tasks/{id}", handleUpdateTask)
		r.Delete("/tasks/{id}", handleDeleteTask)
	})

	log.Printf("Server starting on :%s", port)
	if err := http.ListenAndServe(fmt.Sprintf(":%s", port), r); err != nil {
		log.Fatal(err)
	}
}

func handleHealth(w http.ResponseWriter, r *http.Request) {
	resp := HealthResponse{
		Status:    "ok",
		Timestamp: time.Now().Format(time.RFC3339),
		Version:   "0.1.0",
	}
	writeJSON(w, http.StatusOK, resp)
}

func handleListTasks(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, map[string]interface{}{"tasks": tasks})
}

func handleGetTask(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	for _, t := range tasks {
		if t.ID == id {
			writeJSON(w, http.StatusOK, map[string]interface{}{"task": t})
			return
		}
	}
	writeJSON(w, http.StatusNotFound, map[string]string{"error": "task not found"})
}

func handleCreateTask(w http.ResponseWriter, r *http.Request) {
	var t Task
	if err := json.NewDecoder(r.Body).Decode(&t); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid JSON"})
		return
	}
	t.ID = fmt.Sprintf("%d", len(tasks)+1)
	t.CreatedAt = time.Now().Format(time.RFC3339)
	if t.Status == "" {
		t.Status = "backlog"
	}
	if t.Priority == "" {
		t.Priority = "medium"
	}
	tasks = append(tasks, t)
	writeJSON(w, http.StatusCreated, map[string]interface{}{"task": t})
}

func handleUpdateTask(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	var updates map[string]string
	if err := json.NewDecoder(r.Body).Decode(&updates); err != nil {
		writeJSON(w, http.StatusBadRequest, map[string]string{"error": "invalid JSON"})
		return
	}
	for i, t := range tasks {
		if t.ID == id {
			if v, ok := updates["title"]; ok {
				tasks[i].Title = v
			}
			if v, ok := updates["status"]; ok {
				tasks[i].Status = v
			}
			if v, ok := updates["priority"]; ok {
				tasks[i].Priority = v
			}
			if v, ok := updates["description"]; ok {
				tasks[i].Description = v
			}
			writeJSON(w, http.StatusOK, map[string]interface{}{"task": tasks[i]})
			return
		}
	}
	writeJSON(w, http.StatusNotFound, map[string]string{"error": "task not found"})
}

func handleDeleteTask(w http.ResponseWriter, r *http.Request) {
	id := chi.URLParam(r, "id")
	for i, t := range tasks {
		if t.ID == id {
			tasks = append(tasks[:i], tasks[i+1:]...)
			writeJSON(w, http.StatusOK, map[string]string{"ok": "true"})
			return
		}
	}
	writeJSON(w, http.StatusNotFound, map[string]string{"error": "task not found"})
}

func writeJSON(w http.ResponseWriter, status int, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(data)
}
