class Sys::GroupUser < ApplicationRecord
  belongs_to :group, class_name: "Sys::Group"
  belongs_to :user, class_name: "Sys::User"
end
