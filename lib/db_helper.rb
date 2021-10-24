module DbHelper
  # Determine which database should be read from, base on the current environment.
  def self.reading_role
    configurations.find(&:replica?)&.spec_name&.to_sym || :primary
  end

  def self.configurations
    ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, include_replicas: true)
  end

  # Invoke the reader role manually.
  def self.with_replica(&block)
    if reading_role == :primary
      yield
    else
      ActiveRecord::Base.connected_to(role: :reading, &block)
    end
  end
end
