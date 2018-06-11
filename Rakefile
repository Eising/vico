namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel"
    require "yaml"
    Sequel.extension :migration

    db = Sequel.connect("postgres://#{ENV['ICING_DB_USER']}:#{ENV['ICING_DB_PASSWORD']}@#{ENV['ICING_DB_HOST']}/#{ENV['ICING_DATABASE']}")
    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, "db/migrations")
    end
  end
end
