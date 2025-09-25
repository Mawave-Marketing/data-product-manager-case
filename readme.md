# Case Study: Data Product Manager - Marketing Analytics Platform

## Kontext

Mawave, eine digitale Marketingagentur, möchte ihre Datenplattform erweitern, um bessere Einblicke in die Performance ihrer Kundenkampagnen und interne Ressourcenplanung zu ermöglichen. Als Data Product Manager sollen Sie eine neue Datenprodukt-Initiative leiten.

## Ihre Aufgabe (3-6 Stunden)

**Szenario:** Das Management möchte ein neues "Campaign Performance Dashboard" entwickeln, das Marketing-Teams und Kunden einheitliche, plattformübergreifende Insights bietet. Gleichzeitig sollen interne Teams bessere Einblicke in Ressourcenallokation und Profitabilität erhalten.

### Gegebene Daten

Sie erhalten vereinfachte CSV-Datensätze, die folgende Bereiche abdecken:

- `ad_metrics.csv` - Kampagnen-Performance (Meta, Google Ads, TikTok, Pinterest)
- `time_tracking.csv` - Mitarbeiter-Zeiterfassung (Clockify-ähnlich)
- `clients.csv` - Kundenstammdaten
- `projects.csv` - Projekt-Informationen
- `employees.csv` - Mitarbeiterdaten

## Tasks

### Teil 1: Datenarchitektur & dbt-Implementierung (2-3 Stunden)

Erstellen Sie ein dbt-Projekt mit folgender Struktur:

1. **Integration Layer (IL)**: Raw Data Ingestion
2. **Cleansing Layer (CL)**: Data Cleaning & Standardization
3. **Operational Layer (OL)**: Business-ready models
4. **Business Layer (BL)**: KPI & Reporting models

#### Spezifische Models zu entwickeln:

**Operational Layer:**
- `ol_unified_ad_metrics` - Plattformübergreifende Kampagnen-Metriken
- `ol_client_projects_with_time` - Client-Projekte mit Zeitaufwand
- `ol_campaign_profitability` - Kampagnen mit Kostenschätzungen

**Business Layer:**
- `bl_client_performance_dashboard` - Hauptmodel für Client-Dashboard
- `bl_resource_utilization` - Mitarbeiter-Auslastung nach Kunden/Projekten
- `bl_monthly_campaign_cohorts` - Monatliche Performance-Kohorten nach Kunden

### Teil 2: Stakeholder Management & Business Requirements (1-2 Stunden)

Erstellen Sie ein Dokument mit:

1. **Data Product Vision**: Beschreibung des Campaign Performance Dashboards
2. **Stakeholder Mapping**: Identifizierung und Analyse der verschiedenen Nutzergruppen
3. **KPI Framework**: Definition der wichtigsten Metriken für verschiedene Zielgruppen
4. **Implementation Roadmap**: Priorisierte Entwicklungsschritte

### Teil 3: Datenqualität & Governance (30-60 Minuten)

Implementieren Sie:

- dbt-Tests für kritische Datenqualitätsprüfungen
- Dokumentation der wichtigsten Models in YAML-Dateien
- Data Lineage-Überlegungen

## Erwartete Deliverables

### 1. dbt-Projekt (öffentliches Git-Repository)

- Vollständige Modell-Hierarchie (IL → CL → OL → BL)
- Mindestens 3 aussagekräftige dbt-Tests
- YAML-Dokumentation für BL-Models
- README mit Setup-Anweisungen

### 2. Product Strategy Dokument (2-3 Seiten)

- Business Case für das Data Product
- Stakeholder-Analyse
- KPI-Framework
- Implementation Roadmap mit Zeitschätzungen

### 3. SQL-Beispiele

Typische Analysen, die das Dashboard ermöglichen würde

## Bewertungskriterien

### Technische Exzellenz (40%)
- Saubere, modulare dbt-Implementierung
- Korrekte Anwendung der Layer-Architektur
- Effiziente SQL-Performance-Überlegungen
- Angemessene Datenqualitäts-Tests

### Product Thinking (40%)
- Klare Business-Value-Argumentation
- Realistische Stakeholder-Analyse
- Durchdachtes KPI-Framework
- Pragmatische Roadmap-Priorisierung

### Data Governance (20%)
- Dokumentation und Lineage-Verständnis
- Sicherheitsüberlegungen (PII, Client-Daten)
- Skalierbarkeits-Konzepte

## 📊 Sample-Daten

### Verfügbare Datensätze:

#### `ad_metrics.csv` (ca. 1000 Zeilen)
- Realistische Kampagnen-Performance verschiedener Plattformen
- Verschiedene Attribution Windows
- Client-spezifische Variationen

#### `time_tracking.csv` (ca. 500 Zeilen)
- Mitarbeiter-Zeiterfassung auf Projekte
- Verschiedene Abteilungen/Rollen
- Realistische Stundensätze

#### `clients.csv` (ca. 20 Kunden)
- Verschiedene Branchen
- Unterschiedliche Vertragsgrößen

---

*Diese Case Study ermöglicht es Bewerbern, mit realistischen Datenmengen zu arbeiten, wie sie in einem echten Unternehmensumfeld anzutreffen sind.*