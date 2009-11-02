class Section < ActiveRecord::Base
	has_many :members
	validates_presence_of :name
	validates_presence_of :position
	acts_as_list
	default_scope :order => 'position ASC'
	named_scope :private, :conditions => {:visible => false}
	named_scope :public, :conditions => {:visible => true}
	
	def to_s
		name
	end
end
