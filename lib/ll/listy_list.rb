class LL::ListyList

  def initialize cli: nil,
                 name: nil

    @checklists = []
    @schemas    = []

    name ||= "listy-list".style :forestgreen, :bold

    @cli   = cli
    @cli ||= VV::CLI.new name: name,
                         version: LL::VERSION,
                         argv: ARGV
    self.uri = "/"

    self.first_boot
  end

  def first_boot
    self.create_directories

    self.boot! do
      self.show_help!    if @cli.help?
      self.show_version! if @cli.version?
    end
  end

  def boot!
    @_status = :boot
    yield
    self.load
  end

  def loop
    self.status = :loop unless shutdown?

    while loop? do
      self.load
      self.lock
      self.display
      self.await_input
      self.react
      self.persist
      self.unlock
    end

    self.shutdown
  ensure
    self.unlock
  end

  def react
    consider @input do

      given String.empty_string do
        self.uri = "/"
      end

      given "help" do
        self.uri = "/help"
      end

      given "install" do
        self.uri = "/install"
      end

      within %w[ version v ] do
        self.uri = "/version"
      end

      otherwise do
        self.uri = "/unknown"
      end

    end
  end

  def show_help!
    @cli.print_help
    self.shutdown!
  end

  def show_version
    self.uri = "/version"
    @cli.print_version
  end

  def show_version!
    self.show_version
    self.shutdown!
  end

  def shutdown
    :shutdown_safely
  end

  def shutdown?
    self.status == :shutdown
  end

  def shutdown!
    self.status = :shutdown
  end

  def load
    self.load_schemas
    self.load_checklists
  end
  alias_method :reload, :load

  def load_schemas
    @schemas = LL::Schema.load dir: @cli.data_path
  end

  def load_checklists
    @checklists = LL::Checklist.load dir: @cli.data_path
  end

  def lock_path
    @cli.data_path.file_join "listy.lock"
  end

  # ZACH WAS HERE: run ./bin/listy and hit lock error. Maybe
  #                it was me assuming that a lock would have happened?
  def lock_contents
    File.read(lock_path).chomp
  end

  def lock
    File.write(lock_path, Process.pid.to_s) unless File.exists? lock_path

    return true if lock_contents == Process.pid.to_s

    fail "Unable to lock #{lock_path}, contains pid mismatch."
  end

  def unlock
    message = "Unable to unlock #{lock_path}, contains pid mismatch."
    fail message if lock_contents != Process.pid.to_s

    File.remove lock_path
  end

  def display
    consider self.uri do

      puts self.uri

      given "/help" do
        @cli.print_help
      end

      given "/install" do
        directory = File.pwd.file_join "exe"
        @cli.install( executable_directory: directory )
      end

      given "/version" do
        @cli.print_version
      end

      given "/unknown" do
        @cli.print_error command: @input
      end

    end
  end

  def persist
    self.save_uri
    self.save_checklist
    self.save_schema_changes
    self.sync
  end

  # TOOD: Implement these
  def save_uri
  end
  def save_checklist
  end
  def save_schema_changes
  end
  def sync
  end

  def loop?
    self.status == :loop
  end

  def boot?
    self.status == :boot
  end

  def await_input
    @input = @cli.await_input message: "listy>"
    @input
  end

  # Log this. Maybe incorporate into VV::CLI?
  def uri= uri
    @_uri = uri
  end

  def uri
    @_uri
  end

  def status= status
    message = \
    "Currently shutdown. Call `boot!` to return to resume."
    fail message if self.status == :shutdown
    %i[ loop boot pause shutdown ].includes! status
    @_status = status
  end

  def status
    @_status
  end

  def create_directories
    %w[ checklists schemas ].each do     | _directory |
      directory = @cli.data_path.file_join _directory
      File.make_directory_if_not_exists     directory
    end
  end

end
