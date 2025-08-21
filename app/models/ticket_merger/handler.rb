module TicketMerger
  
  
  class FileArtifact < StringIO
    attr_reader :content_type
    
    attr_reader :initialized
    attr_reader :original_filename
    attr_reader :path
    attr_reader :description
    
    def empty?
     (!initialized?) || size == 0 
    end
    
    def initialized?
      !! @initialized 
    end
    
    def initialize(path,original_name,description,files_with_mime_types,mode=nil)
      if File.exist?(path)
        super(File.read(path,mode)) 
        self.set_content_type_from_mime_types(files_with_mime_types)    
        @description = description
        @path = path
        @original_filename = original_name
        @initialized = true
      end
    end
    
    class << self
      
      def read(hash_for_files=[],files_with_mime_types={})  
        files_with_mime_types =  YAML.load(File.popen("file -i " + hash_for_files.collect{|hash| "'#{hash[:path]}'"}.join(' ') )) unless hash_for_files.blank?
        hash_for_files.collect do |hash| 
          self.new(hash[:path],hash[:original_filename],hash[:description],files_with_mime_types )
          end.delete_if(&:empty?).inject({}){|memo,f| memo[f.path] = f;memo}
        end        
      end
      
      protected
      
      def set_content_type_from_mime_types(files_with_mime_types={})
        @content_type = files_with_mime_types[self.path]
      end
      
    end
    
    
    class Handler
      attr_reader :from_issue, :to_issue
      attr_accessor :journal, :unsaved_attachments, :attached_attachments, :time_entries
      
      def initialize(from, to)
        @from_issue = Issue.find(from)
        @to_issue = Issue.find(to)
        validate_merge_conditions
        prepare
        save
      end
      
      def save
        @to_issue.save!
      end
      
      def separator
        "\n"
      end
      
      def time_entries
        @time_entries ||= []
      end
      
      def attached_attachments
        @attached_attachments ||= []
      end
      
      def unsaved_attachments
        @unsaved_attachments ||= []
      end
      
      private
      
      def validate_merge_conditions
        raise "Quell- und Ziel-Ticket müssen im gleichen Projekt sein" unless from_issue.project_id == to_issue.project_id
        raise "Quell-Ticket ist bereits geschlossen" if from_issue.closed?
        raise "Ziel-Ticket ist geschlossen" if to_issue.closed?
      end
      
      # Merge der Journals
      def merge_journals
        notes = "* Ticket ##{from_issue.id} : "
        notes << [
          from_issue.description,
          from_issue.journals.includes(:details).order(created_on: :asc).map(&:notes)
        ].flatten.compact.join(separator)
        
        self.journal = to_issue.journals.build(
          user_id: User.current.id,
          notes: notes
        )
      end
      
      # Merge der Anhänge
      def merge_attachments
        from_issue.attachments.each do |attachment|
          next unless attachment && attachment.diskfile && File.exist?(attachment.diskfile)
          
          new_attachment = Attachment.new(
            container: to_issue,
            file: File.open(attachment.diskfile),
            filename: attachment.filename,
            description: "Ticket ##{from_issue.id}: #{attachment.description}".strip,
            author: User.current
          )
          
          if new_attachment.save
            self.attached_attachments << new_attachment
          else
            self.unsaved_attachments << new_attachment
          end
        end
      end
      
      # Clone der Zeiteinträge
      def merge_time_entries
        from_issue.time_entries.each do |time_entry|
          new_time_entry = TimeEntry.new(
            project: to_issue.project,
            issue: to_issue,
            user: time_entry.user,
            activity: time_entry.activity,
            hours: time_entry.hours,
            comments: "Ticket ##{from_issue.id}: #{time_entry.comments}".strip,
            spent_on: time_entry.spent_on
          )
          
          if new_time_entry.save
            self.time_entries << new_time_entry
          end
        end
      end
      
      def prepare
        merge_journals
        merge_time_entries
        merge_attachments
        
        # Quell-Ticket als zusammengeführt markieren
        from_issue.status = IssueStatus.find_by(name: 'Merged') || IssueStatus.find_by(is_closed: true)
        from_issue.save!
        
        # Verknüpfung zwischen den Tickets erstellen
        create_issue_relation
      end
      
      def create_issue_relation
        IssueRelation.create!(
          issue_from: from_issue,
          issue_to: to_issue,
          relation_type: 'relates'
        )
      rescue ActiveRecord::RecordInvalid
        # Relation existiert bereits oder kann nicht erstellt werden
      end
    end
  end
