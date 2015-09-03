class JoinCauseService < Aldous::Service
	NOT_UNIQUE_RELATIONSHIP_INDICATOR = "User has already been taken"
	def initialize(user, cause)
		@user = user
		@cause = cause
	end

	def perform
		relationship = UserCauseRelationship.new
		relationship.user_id = @user.id
		relationship.cause_id = @cause.id
		createOrUpdateIfNecessary(relationship)
	end

	private
		def update_user_current_cause_info(user,current_cause)
			user.update_attribute(:current_cause_id, current_cause.id)
			user.update_attribute(:current_cause_name, current_cause.name)
			user.update_attribute(:current_cause_join_date, Time.now)
		end

		''' Create a new relationship if user has not joined this cause
			Update updated_at timestamp if user has joined this cause previously
		 '''
		def createOrUpdateIfNecessary(new_relationship)
			user_relationships = @user.user_cause_relationships
			duplicate_relationship = find_duplicate_relationship(new_relationship)
			if duplicate_relationship.present?
				if duplicate_relationship.update_attribute(:updated_at, Time.now)
					update_user_current_cause_info(@user,@cause)
					Result::Success.new(result: @cause)
				else
					Result::Failure.new(errors: duplicate_relationship.errors.full_messages)
				end
			else
				if new_relationship.save
					update_user_current_cause_info(@user,@cause)
					Result::Success.new(result: @cause)
				else
					Result::Failure.new(errors: new_relationship.errors.full_messages)
				end
			end
		end

		def find_duplicate_relationship(new_relationship)
			for relationship in @user.user_cause_relationships
				if relationship.cause_id == new_relationship.cause_id 
					return relationship
				end
			end
			return nil
		end
end