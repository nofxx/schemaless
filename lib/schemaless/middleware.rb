class SchemalessMiddleware

  def initialize(app)
    @app = app
  end

  def call(env)
    ::Schemaless::Work.run!
  end

end
