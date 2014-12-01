# Runs schemaless on rails calls
class SchemalessMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    # return if env =~ /production/
    puts "Schemaless running on #{@app}"
    ::Schemaless::Worker.run!
    @app.call(env)
  end
end
