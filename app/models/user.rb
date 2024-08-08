class User < ApplicationRecord

  include AttrJson::Record
  include AttrJson::Record::Dirty
  include AttrJson::Record::QueryScopes

  has_paper_trail


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:confirmable, :lockable, :trackable

  has_one_attached :image
  belongs_to :role
  belongs_to :company


  scope :date_select_order, -> (enum = '') {
    order("#{enum}": :asc)
  }
  scope :company_id_eq, -> (enum = '') {
    order("#{enum}": :asc)
  }
  scope :date_select_order_status, -> (enum = '') {
    order("#{enum}": :asc)
  }
  scope :name_or_email_cont, -> (enum = '') {
    order("#{enum}": :asc)
  }
  def self.ransackable_scopes(auth_object = nil)
    %i(borrower_type_current_eq date_select_order date_select_order_status name_or_email_cont company_id_eq)
  end
end
