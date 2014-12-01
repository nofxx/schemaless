# Runs schemaless on rails calls
class SchemalessMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    return if env =~ /production/
    puts "Schemaless running on #{env} mode"
    ::Schemaless::Worker.run!
  end
end
