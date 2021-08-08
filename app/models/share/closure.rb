class Share::Closure < ApplicationRecord
  self.table_name = "share_closures"

  belongs_to :parent, class_name: "Share::Base"
  belongs_to :child, class_name: "Share::Base"
end
