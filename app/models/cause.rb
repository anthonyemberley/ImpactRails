class Cause < ActiveRecord::Base
	validates :name :uniquness => true, :presence => true

	#TODO make sure cause is one of the finite number of categories we have
	validates :category :presence => true
	validates :description :presence => true






end
