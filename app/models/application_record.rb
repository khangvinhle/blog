class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  connects_to(database: { writing: :primary, reading: DbHelper.reading_role })
end
