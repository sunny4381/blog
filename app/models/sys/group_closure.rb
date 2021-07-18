class Sys::GroupClosure < ApplicationRecord
  belongs_to :parent, class_name: "Sys::Group"
  belongs_to :child, class_name: "Sys::Group"
end
