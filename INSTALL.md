# Installationsanleitung für Redmine Ticket Merger Plugin

## Voraussetzungen

- Redmine 6.0.0 oder höher
- Ruby 2.7 oder höher
- Rails 6.x
- MySQL, PostgreSQL oder SQLite

## Schritt-für-Schritt Installation

### 1. Plugin herunterladen

```bash
cd /path/to/redmine/plugins
git clone https://github.com/leanderkretschmer/redmine_ticket_merger.git
```

### 2. Abhängigkeiten installieren

```bash
cd redmine_ticket_merger
bundle install
```

### 3. Datenbank-Migrationen ausführen (falls erforderlich)

```bash
cd /path/to/redmine
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

### 4. Assets kompilieren

```bash
bundle exec rake assets:precompile RAILS_ENV=production
```

### 5. Redmine neu starten

```bash
# Für Apache/Passenger
touch tmp/restart.txt

# Für Unicorn
pkill -f unicorn
bundle exec unicorn -c config/unicorn.rb -E production -D

# Für Puma
pkill -f puma
bundle exec puma -C config/puma.rb -e production
```

### 6. Berechtigungen konfigurieren

1. Melden Sie sich als Administrator an
2. Gehen Sie zu **Administration** → **Rollen und Berechtigungen**
3. Wählen Sie die Rolle aus, die Tickets zusammenführen können soll
4. Aktivieren Sie die Berechtigung **"Tickets zusammenführen"**
5. Klicken Sie auf **"Speichern"**

## Verwendung

### Erste Schritte

1. Gehen Sie zu einem Projekt in Redmine
2. Im Projektmenü erscheint jetzt **"Tickets zusammenführen"**
3. Klicken Sie darauf, um die Merge-Funktion zu öffnen

### Tickets zusammenführen

1. **Quell-Ticket auswählen**: Das Ticket, das zusammengeführt werden soll
2. **Ziel-Ticket auswählen**: Das Ticket, in das zusammengeführt werden soll
3. **Warnungen lesen**: Die Seite zeigt wichtige Hinweise an
4. **Zusammenführung bestätigen**: Klicken Sie auf "Tickets zusammenführen"

## Fehlerbehebung

### Plugin wird nicht angezeigt

- Prüfen Sie, ob das Plugin in der Plugin-Liste erscheint (Administration → Plugins)
- Stellen Sie sicher, dass Redmine neu gestartet wurde
- Prüfen Sie die Logs auf Fehler

### Berechtigungsfehler

- Stellen Sie sicher, dass die Berechtigung für die entsprechende Rolle aktiviert ist
- Prüfen Sie, ob der Benutzer Mitglied des Projekts ist

### Datenbankfehler

```bash
# Migrationen zurücksetzen
bundle exec rake redmine:plugins:migrate NAME=redmine_ticket_merger VERSION=0 RAILS_ENV=production

# Migrationen erneut ausführen
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

### Assets-Probleme

```bash
# Assets löschen und neu kompilieren
bundle exec rake assets:clobber RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production
```

## Deinstallation

### 1. Plugin deaktivieren

1. Gehen Sie zu **Administration** → **Plugins**
2. Klicken Sie auf **"Deaktivieren"** beim Ticket Merger Plugin

### 2. Plugin entfernen

```bash
cd /path/to/redmine/plugins
rm -rf redmine_ticket_merger
```

### 3. Redmine neu starten

```bash
touch tmp/restart.txt
```

## Support

Bei Problemen:

1. Prüfen Sie die Redmine-Logs: `log/production.log`
2. Prüfen Sie die Plugin-Logs: `log/redmine_ticket_merger.log`
3. Erstellen Sie ein Issue auf GitHub mit:
   - Redmine-Version
   - Ruby-Version
   - Rails-Version
   - Fehlermeldung
   - Schritte zur Reproduktion
