# Serverless Image Processing Pipeline ☁️🖼️

**Status: Work in Progress (WIP) 🚧**

Dieses Repository beinhaltet den Code und die Infrastruktur-Definitionen für unsere Transferarbeit im Modul "Cloud und Serverless". Wir sind eine vierköpfige Gruppe von Studenten und entwerfen in diesem Rahmen eine skalierbare, ereignisgesteuerte Architektur zur Bildverarbeitung.

## Über das Projekt
Das Ziel dieser Arbeit ist es, die Vorteile von Serverless-Technologien gegenüber klassischen IaaS-Lösungen (Infrastructure as a Service) praktisch und analytisch aufzuzeigen. Besonderer Fokus liegt dabei auf Kosteneffizienz, Skalierbarkeit auf Null und einer hohen Automatisierung.

Der geplante Ablauf der Applikation ist simpel gehalten, um den Fokus auf die Infrastruktur zu legen:
1. Ein Benutzer lädt über ein minimalistisches statisches Web-Frontend ein Bild hoch.
2. Das Bild wird in einem Cloud-Objektspeicher abgelegt.
3. Dieser Upload triggert automatisch eine isolierte Cloud-Funktion.
4. Die Funktion verarbeitet das Bild (z.B. Resizing, Metadaten-Extraktion) und speichert das Resultat.

## Tech Stack
Basierend auf unserer initialen Nutzwertanalyse haben wir uns für folgende Technologien entschieden:

* **Cloud Provider:** Google Cloud Platform (GCP)
* **Compute:** Google Cloud Functions (Event-Driven)
* **Storage:** Google Cloud Storage (Buckets)
* **Infrastructure as Code (IaC):** OpenTofu (zur reproduzierbaren Bereitstellung der Infrastruktur)
* **Lokale Entwicklung:** Google Cloud Functions Framework (um Kosten während der Entwicklung zu vermeiden)
* **Frontend:** Statisches HTML/JS

## Repository Struktur
* `/frontend`: Beinhaltet die statische Webseite für den Bild-Upload.
* `/infrastructure`: Die OpenTofu-Konfigurationsdateien (`.tf`) zur Automatisierung der Google Cloud Umgebung.
* `/src/image-processing`: Der Quellcode der einzelnen Serverless-Funktionen.

---
*Hinweis: Da sich das Projekt aktuell noch im Aufbau befindet, werden detaillierte Anleitungen zum Deployment (OpenTofu) und zur lokalen Ausführung der Funktionen zu einem späteren Zeitpunkt hier ergänzt.*