class Status
  BoolFields = [
    'mean_publication',
    'mean_event',
    'mean_manifestation',
    'mean_others'
  ]

  def initialize(params)
    @params = params
  end

  def method_missing(key, *args)
    if BoolFields.include? key.to_s
      case @params[key.to_s]
      when 'true', 'on', '1'
        true
      when 'false', 'off', '0', nil
        false
      else
        raise NotBooleanValueError,
              "#{@params[key]} is not representing a boolean value"
      end
    else
      @params[key]
    end
  end

  class NotBooleanValueError < StandardError ; end
end
