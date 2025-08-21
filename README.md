# Redmine Ticket Merger Plugin

Ein Redmine Plugin zum Zusammenführen von Tickets (Issues) innerhalb desselben Projekts.

## Features

- **Sichere Zusammenführung**: Tickets können nur innerhalb desselben Projekts zusammengeführt werden
- **Vollständige Datenübertragung**: 
  - Alle Anhänge werden kopiert
  - Alle Zeiteinträge werden übertragen
  - Alle Kommentare und Änderungen werden zusammengeführt
- **Automatische Verknüpfung**: Erstellt eine Relation zwischen den Tickets
- **Status-Management**: Das Quell-Ticket wird automatisch geschlossen
- **Benutzerfreundliche Oberfläche**: Einfaches Web-Interface zur Ticket-Auswahl

## Kompatibilität

- Redmine 6.0.0 oder höher
- Rails 6.x
- Ruby 2.7 oder höher

## Installation

1. **Plugin herunterladen**:
   ```bash
   cd /path/to/redmine/plugins
   git clone https://github.com/leanderkretschmer/redmine_ticket_merger.git
   ```

2. **Plugin installieren**:
   ```bash
   cd redmine_ticket_merger
   bundle install
   ```

3. **Redmine neu starten**:
   ```bash
   cd /path/to/redmine
   rails restart
   ```

4. **Berechtigungen konfigurieren**:
   - Gehen Sie zu Administration → Rollen und Berechtigungen
   - Aktivieren Sie die Berechtigung "Tickets zusammenführen" für die gewünschten Rollen

## Verwendung

1. **Zugriff auf Merge-Funktion**:
   - Gehen Sie zu einem Projekt
   - Klicken Sie auf "Tickets zusammenführen" im Projektmenü

2. **Tickets auswählen**:
   - Wählen Sie das Quell-Ticket (das zusammengeführt werden soll)
   - Wählen Sie das Ziel-Ticket (in das zusammengeführt werden soll)

3. **Zusammenführung bestätigen**:
   - Lesen Sie die Warnungen sorgfältig durch
   - Klicken Sie auf "Tickets zusammenführen"

## Sicherheitshinweise

⚠️ **Wichtig**: Das Zusammenführen von Tickets ist **nicht rückgängig** zu machen!

- Stellen Sie sicher, dass Sie die richtigen Tickets ausgewählt haben
- Das Quell-Ticket wird automatisch geschlossen
- Alle Daten werden in das Ziel-Ticket übertragen

## Technische Details

### Was passiert beim Zusammenführen?

1. **Validierung**: Prüfung, ob beide Tickets im gleichen Projekt sind und nicht geschlossen sind
2. **Anhänge kopieren**: Alle Dateien werden in das Ziel-Ticket kopiert
3. **Zeiteinträge übertragen**: Alle Zeiterfassungen werden übertragen
4. **Kommentare zusammenführen**: Alle Journal-Einträge werden in einem neuen Kommentar zusammengefasst
5. **Relation erstellen**: Eine Verknüpfung zwischen den Tickets wird erstellt
6. **Status ändern**: Das Quell-Ticket wird geschlossen

### Dateistruktur

```
redmine_ticket_merger/
├── app/
│   ├── controllers/
│   │   └── issues_controller.rb
│   ├── models/
│   │   └── ticket_merger/
│   │       └── handler.rb
│   └── views/
│       └── issues/
│           └── merge_form.html.erb
├── assets/
│   └── stylesheets/
│       └── ticket_merger.css
├── config/
│   └── routes.rb
├── lang/
│   ├── de.yml
│   └── en.yml
├── init.rb
└── README.md
```

## Entwicklung

### Voraussetzungen

- Redmine 6.x Entwicklungsumgebung
- Ruby 2.7+
- Rails 6.x

### Tests ausführen

```bash
cd /path/to/redmine
bundle exec rake redmine:plugins:test RAILS_ENV=test NAME=redmine_ticket_merger
```

## Lizenz

Dieses Plugin steht unter der MIT-Lizenz.

## Support

Bei Problemen oder Fragen erstellen Sie bitte ein Issue auf GitHub.

## Changelog

### Version 2.0.0
- Vollständige Modernisierung für Redmine 6
- Neue Benutzeroberfläche
- Verbesserte Fehlerbehandlung
- Deutsche und englische Lokalisierung
- Responsive Design
- Sicherheitsverbesserungen
