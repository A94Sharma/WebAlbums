class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
   has_many :albums, dependent: :destroy
   has_many :pictures, through: :albums, dependent: :destroy

   has_many :articles, dependent: :destroy
   has_many :comments, through: :articles, dependent: :destroy

   has_many :comments
   has_many :commentables, through: :comments
end
