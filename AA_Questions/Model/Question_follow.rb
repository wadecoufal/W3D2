
class QuestionFollow
  attr_reader :questions_id, :users_id
  
  def initialize(options)
    @questions_id = options['questions_id']
    @users_id = options['users_id']
  end
  
  def self.followers_for_question_id(question_id)
    user_followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM 
        questions
      JOIN
        question_follows
        ON question_follows.questions_id = questions.id
      JOIN 
        users 
        ON question_follows.users_id = users.id
      WHERE 
        question_follows.questions_id = ?
    SQL
    
    return nil unless user_followers.length > 0
    user_followers.map {|follower| User.new(follower)}
  end
  
  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM 
        questions
      JOIN
        question_follows
        ON question_follows.questions_id = questions.id
      JOIN 
        users 
        ON question_follows.users_id = users.id
      WHERE 
        question_follows.users_id = ?
    SQL
    
    return nil unless questions.length > 0
    questions.map {|question| Question.new(question)}
  end
  
  
  def self.most_followed_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM 
        questions
      JOIN question_follows
        ON question_follows.questions_id = questions.id
      JOIN users
        ON question_follows.users_id = users.id
      GROUP BY
        questions.id 
      ORDER BY 
        COUNT(*) DESC
      LIMIT
        ?
      SQL
    return nil if questions.empty?
    questions.map {|question| Question.new(question)}
  end
  
end