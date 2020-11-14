class ApplicationOperation
  def initialize(*args)
    @errors = []
    @resource = nil
  end

  def self.call(*args)
    new(*args).call
  end

  private

  def result
    OpenStruct.new(success?: !@errors.present?, data: @resource, errors: @errors)
  end
end
