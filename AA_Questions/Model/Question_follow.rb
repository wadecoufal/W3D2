
class QuestionFollow
  attr_reader :question_id, :users_id
  
  def initialize(options)
    @questions_id = options['questions_id']
    @users_id = options['users_id']
  end
  
  
  
end